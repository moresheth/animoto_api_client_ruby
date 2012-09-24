require 'base64'
require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Animoto::Client do
  def client options = {}
    @client ||= Animoto::Client.new "joe", "secret", options.merge(:logger => ::Logger.new('/dev/null'))
  end

  def object
    @object ||= Object.new
  end

  describe "supplying credentials and endpoint" do
    describe "manually" do
      it "should accept the key and secret as the first two parameters on initialization" do
        c = Animoto::Client.new "key", "secret"
        c.key.should == "key"
        c.secret.should == "secret"
      end
      
      it "should accept an endpoint as an option" do
        c = Animoto::Client.new "key", "secret", :endpoint => "https://platform.animoto.com/"
        c.endpoint.should == "https://platform.animoto.com/"
      end
      
      describe "when the secret isn't specified (i.e. only 1 parameter was passed)" do
        before do
          File.stubs(:exist?).returns(false) # <= to keep it from finding our .animotorc files
        end
        
        it "should raise an error" do
          lambda { Animoto::Client.new "key" }.should raise_error
        end
      end
      
      describe "when the endpoint isn't specified" do
        it "should set the endpoint to the default" do
          c = Animoto::Client.new "key", "secret"
          c.endpoint.should == Animoto::Client::API_ENDPOINT
        end
      end
    end
    
    describe "automatically" do
      before do
        @here_path  = File.expand_path("./.animotorc")
        @home_path  = File.expand_path("~/.animotorc")
        @etc_path   = "/etc/.animotorc"
        @config     = "key: joe\nsecret: secret\nendpoint: https://platform.animoto.com/"
      end
      
      describe "when ./.animotorc exists" do
        before do
          File.stubs(:exist?).with(@here_path).returns(true)
          File.stubs(:read).with(@here_path).returns(@config)
        end
        
        it "should configure itself based on the options in ~/.animotorc" do
          c = Animoto::Client.new
          c.key.should == "joe"
          c.secret.should == "secret"
          c.endpoint.should == "https://platform.animoto.com/"
        end
      end
      
      describe "when ./.animotorc doesn't exist" do
        before do
          File.stubs(:exist?).with(@here_path).returns(false)
        end
        
        describe "when ~/.animotorc exists" do
          before do
            File.stubs(:exist?).with(@home_path).returns(true)
            File.stubs(:read).with(@home_path).returns(@config)
          end
        
          it "should configure itself based on the options in ~/.animotorc" do
            c = Animoto::Client.new
            c.key.should == "joe"
            c.secret.should == "secret"
            c.endpoint.should == "https://platform.animoto.com/"
          end
        end
      
        describe "when ~/.animotorc doesn't exist" do
          before do
            File.stubs(:exist?).with(@home_path).returns(false)
          end
        
          describe "when /etc/.animotorc exists" do
            before do
              File.stubs(:exist?).with(@etc_path).returns(true)
              File.stubs(:read).with(@etc_path).returns(@config)
            end
          
            it "should configure itself based on the options in /etc/.animotorc" do
              c = Animoto::Client.new
              c.key.should == "joe"
              c.secret.should == "secret"
            end
          end
        
          describe "when /etc/.animotorc doesn't exist" do
            it "should raise an error" do
              lambda { Animoto::Client.new }.should raise_error
            end
          end
        end
      end
    end
  end
    
  describe "finding an instance by identifier" do
    before do
      @url = "https://joe:secret@platform.animoto.com/storyboards/1"
      hash = {
        'response'=>{
          'status'=>{'code'=>200},
          'payload'=>{
            'storyboard'=>{
              'links'=>{'self'=>@url,'preview'=>'http://animoto.com/preview/1.mp4'},
              'metadata'=>{
                'duration'=>100,
                'visuals' => [
                  'https://foo.com/1'
                ]
              }
            }
          }
        }
      }
      body = client.response_parser.unparse(hash)
      stub_request(:get, @url).to_return(:body => body, :status => [200,"OK"])
    end
    
    it "should make a GET request to the given url" do
      client.find(Animoto::Resources::Storyboard, @url)
      WebMock.should have_requested(:get, @url)
    end
    
    it "should ask for a response in the proper format" do
      client.find(Animoto::Resources::Storyboard, @url)
      WebMock.should have_requested(:get, @url).with(:headers => { 'Accept' => "application/vnd.animoto.storyboard-v1+json" })
    end
    
    it "should not sent a request body" do
      client.find(Animoto::Resources::Storyboard, @url)
      WebMock.should have_requested(:get, @url).with(:body => "")
    end
    
    it "should return an instance of the correct resource type" do
      client.find(Animoto::Resources::Storyboard, @url).should be_an_instance_of(Animoto::Resources::Storyboard)
    end    
  end
  
  describe "reloading an instance" do
    before do
      @url = 'https://joe:secret@platform.animoto.com/jobs/directing/1'
      @job = Animoto::Resources::Jobs::Directing.new :state => 'initial', :url => @url
      hash = {'response'=>{'status'=>{'code'=>200},'payload'=>{'directing_job'=>{'state'=>'retrieving_assets','links'=>{'self'=>@url,'storyboard'=>'https://platform.animoto.com/storyboards/1'}}}}}
      body = client.response_parser.unparse(hash)
      stub_request(:get, @url).to_return(:body => body, :status => [200,"OK"])
      @job.state.should == 'initial' # sanity check
    end
    
    it "should make a GET request to the resource's url" do
      client.reload!(@job)
      WebMock.should have_requested(:get, @job.url)
    end
    
    it "should ask for a response in the proper format" do
      client.reload!(@job)
      WebMock.should have_requested(:get, @job.url).with(:headers => { 'Accept' => "application/vnd.animoto.directing_job-v1+json" })
    end
    
    it "should not send a request body" do
      client.reload!(@job)
      WebMock.should have_requested(:get, @job.url).with(:body => "")
    end
    
    it "should update the resource's attributes" do
      client.reload!(@job)
      @job.state.should == 'retrieving_assets'
    end
  end
  
  describe "deleting an instance" do
    before do
      @url = 'https://joe:secret@platform.animoto.com/storyboards/1'
      @storyboard = Animoto::Resources::Storyboard.new :url => @url
      stub_request(:delete, @url).to_return(:body => nil, :status => [204,"No Content"])
    end
    
    it "should make a DELETE request to the resource's url" do
      client.delete!(@storyboard)
      WebMock.should have_requested(:delete, @storyboard.url)
    end
    
    it "should not send a request body" do
      client.delete!(@storyboard)
      WebMock.should have_requested(:delete, @storyboard.url).with(:body => "")
    end
    
    it "should return true if successful" do
      client.delete!(@storyboard).should equal(true)
    end
    
    it "should raise an error if unsuccessful" do
      stub_request(:delete, @url).to_return(:body => nil, :status => [404,"Not Found"])
      lambda { client.delete!(@storyboard) }.should raise_error(Animoto::HTTPError)
    end
  end
  
  describe "directing" do
    before do
      @manifest = Animoto::Manifests::Directing.new
      hash = {'response'=>{'status'=>{'code'=>201},'payload'=>{'directing_job'=>{'state'=>'retrieving_assets','links'=>{'self'=>'https://platform.animoto.com/jobs/directing/1'}}}}}
      body = client.response_parser.unparse(hash)
      @endpoint = client.endpoint.sub('https://','https://joe:secret@').chomp('/') + Animoto::Resources::Jobs::Directing.endpoint
      stub_request(:post, @endpoint).to_return(:body => body, :status => [201,"Created"])
    end
    
    it "should make a POST request to the directing jobs' endpoint" do
      client.direct!(@manifest)
      WebMock.should have_requested(:post, @endpoint)
    end
    
    it "should ask for a response in the proper format" do
      client.direct!(@manifest)
      WebMock.should have_requested(:post, @endpoint).with(:headers => { "Accept" => "application/vnd.animoto.directing_job-v1+json" })
    end
    
    it "should send the serialized manifest as the request body" do
      client.direct!(@manifest)
      WebMock.should have_requested(:post, @endpoint).with(:body => client.response_parser.unparse(@manifest.to_hash))
    end

    it "should give the request body in the proper format" do
      client.direct!(@manifest)
      WebMock.should have_requested(:post, @endpoint).with(:headers => { "Content-Type" => "application/vnd.animoto.directing_manifest-v1+json" })
    end
    
    it "should return a directing job" do
      client.direct!(@manifest).should be_an_instance_of(Animoto::Resources::Jobs::Directing)
    end
  end
  
  describe "rendering" do
    before do
      @manifest = Animoto::Manifests::Rendering.new
      hash = {'response'=>{'status'=>{'code'=>201},'payload'=>{'rendering_job'=>{'state'=>'rendering','links'=>{'self'=>'https://platform.animoto.com/jobs/rendering/1'}}}}}
      body = client.response_parser.unparse(hash)
      @endpoint = client.endpoint.sub('https://','https://joe:secret@').chomp('/') + Animoto::Resources::Jobs::Rendering.endpoint
      stub_request(:post, @endpoint).to_return(:body => body, :status => [201,"Created"])
    end
    
    it "should make a POST request to the rendering jobs' endpoint" do
      client.render!(@manifest)
      WebMock.should have_requested(:post, @endpoint)
    end
    
    it "should ask for a response in the proper format" do
      client.render!(@manifest)
      WebMock.should have_requested(:post, @endpoint).with(:headers => { "Accept" => "application/vnd.animoto.rendering_job-v1+json" })
    end
    
    it "should send the serialized manifest as the request body" do
      client.render!(@manifest)
      WebMock.should have_requested(:post, @endpoint).with(:body => client.response_parser.unparse(@manifest.to_hash))
    end

    it "should give the request body in the proper format" do
      client.render!(@manifest)
      WebMock.should have_requested(:post, @endpoint).with(:headers => { "Content-Type" => "application/vnd.animoto.rendering_manifest-v1+json" })
    end
    
    it "should return a rendering job" do
      client.render!(@manifest).should be_an_instance_of(Animoto::Resources::Jobs::Rendering)
    end
  end
  
  describe "directing and rendering" do
    before do
      @manifest = Animoto::Manifests::DirectingAndRendering.new
      hash = {'response'=>{'status'=>{'code'=>201},'payload'=>{'directing_and_rendering_job'=>{'state'=>'retrieving_assets','links'=>{'self'=>'https://platform.animoto.com/jobs/directing_and_rendering/1'}}}}}
      body = client.response_parser.unparse(hash)
      @endpoint = client.endpoint.sub('https://','https://joe:secret@').chomp('/') + Animoto::Resources::Jobs::DirectingAndRendering.endpoint
      stub_request(:post, @endpoint).to_return(:body => body, :status => [201,"Created"])
    end
    
    it "should make a POST request to the directing_and_rendering jobs' endpoint" do
      client.direct_and_render!(@manifest)
      WebMock.should have_requested(:post, @endpoint)
    end
    
    it "should ask for a response in the proper format" do
      client.direct_and_render!(@manifest)
      WebMock.should have_requested(:post, @endpoint).with(:headers => { "Accept" => "application/vnd.animoto.directing_and_rendering_job-v1+json" })
    end
    
    it "should send the serialized manifest as the request body" do
      client.direct_and_render!(@manifest)
      WebMock.should have_requested(:post, @endpoint).with(:body => client.response_parser.unparse(@manifest.to_hash))
    end

    it "should give the request body in the proper format" do
      client.direct_and_render!(@manifest)
      WebMock.should have_requested(:post, @endpoint).with(:headers => { "Content-Type" => "application/vnd.animoto.directing_and_rendering_manifest-v1+json" })
    end
    
    it "should return a directing job" do
      client.direct_and_render!(@manifest).should be_an_instance_of(Animoto::Resources::Jobs::DirectingAndRendering)
    end
  end
  
  describe "bundling" do
    before do
      @manifest = Animoto::Manifests::StoryboardBundling.new
      hash = {'response'=>{'status'=>{'code'=>201},'payload'=>{'storyboard_bundling_job'=>{'state'=>'bundling','links'=>{'self'=>'https://platform.animoto.com/jobs/storyboard_bundling/1'}}}}}
      body = client.response_parser.unparse(hash)
      @endpoint = client.endpoint.sub('https://','https://joe:secret@').chomp('/') + Animoto::Resources::Jobs::StoryboardBundling.endpoint
      stub_request(:post, @endpoint).to_return(:body => body, :status => [201,"Created"])
    end
    
    it "should make a POST request to the bundling jobs' endpoint" do
      client.bundle!(@manifest)
      WebMock.should have_requested(:post, @endpoint)
    end
    
    it "should ask for a response in the proper format" do
      client.bundle!(@manifest)
      WebMock.should have_requested(:post, @endpoint).with(:headers => { "Accept" => "application/vnd.animoto.storyboard_bundling_job-v1+json" })
    end
    
    it "should send the serialized manifest as the request body" do
      client.bundle!(@manifest)
      WebMock.should have_requested(:post, @endpoint).with(:body => client.response_parser.unparse(@manifest.to_hash))
    end

    it "should give the request body in the proper format" do
      client.bundle!(@manifest)
      WebMock.should have_requested(:post, @endpoint).with(:headers => { "Content-Type" => "application/vnd.animoto.storyboard_bundling_manifest-v1+json" })
    end
    
    it "should return a directing job" do
      client.bundle!(@manifest).should be_an_instance_of(Animoto::Resources::Jobs::StoryboardBundling)
    end
  end
  
  describe "unbundling" do
    before do
      @manifest = Animoto::Manifests::StoryboardUnbundling.new
      hash = {'response'=>{'status'=>{'code'=>201},'payload'=>{'storyboard_unbundling_job'=>{'state'=>'unbundling','links'=>{'self'=>'https://platform.animoto.com/jobs/storyboard_unbundling/1'}}}}}
      body = client.response_parser.unparse(hash)
      @endpoint = client.endpoint.sub('https://','https://joe:secret@').chomp('/') + Animoto::Resources::Jobs::StoryboardUnbundling.endpoint
      stub_request(:post, @endpoint).to_return(:body => body, :status => [201,"Created"])
    end
    
    it "should make a POST request to the storyboard unbundling jobs' endpoint" do
      client.unbundle!(@manifest)
      WebMock.should have_requested(:post, @endpoint)
    end
    
    it "should ask for a response in the proper format" do
      client.unbundle!(@manifest)
      WebMock.should have_requested(:post, @endpoint).with(:headers => { "Accept" => "application/vnd.animoto.storyboard_unbundling_job-v1+json" })
    end
    
    it "should send the serialized manifest as the request body" do
      client.unbundle!(@manifest)
      WebMock.should have_requested(:post, @endpoint).with(:body => client.response_parser.unparse(@manifest.to_hash))
    end

    it "should give the request body in the proper format" do
      client.unbundle!(@manifest)
      WebMock.should have_requested(:post, @endpoint).with(:headers => { "Content-Type" => "application/vnd.animoto.storyboard_unbundling_manifest-v1+json" })
    end
    
    it "should return a directing job" do
      client.unbundle!(@manifest).should be_an_instance_of(Animoto::Resources::Jobs::StoryboardUnbundling)
    end    
  end
end