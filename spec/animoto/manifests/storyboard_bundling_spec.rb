require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Animoto::Manifests::StoryboardBundling do
  
  describe "initialization" do
    before do
      @storyboard = Animoto::Resources::Storyboard
    end
    
    it "should take a storyboard as the first argument" do
      Animoto::Manifests::StoryboardBundling.new(@storyboard).storyboard.should == @storyboard
    end
    
    it "should take :http_callback_url and :http_callback_format parameters to set the callback" do
      manifest = Animoto::Manifests::StoryboardBundling.new(@storyboard, :http_callback_url => "http://website.com/callback", :http_callback_format => 'xml')
      manifest.http_callback_url.should == "http://website.com/callback"
      manifest.http_callback_format.should == 'xml'
    end
  end
  
  describe "generating a hash" do
    before do
      @storyboard = Animoto::Resources::Storyboard.new
      @url = "http://platform.animoto.com/storyboards/1"
      @storyboard.instance_variable_set(:@url, @url)
      @manifest = Animoto::Manifests::StoryboardBundling.new(@storyboard)
    end

    it "should have a top-level storyboard_bundling_job object" do
      @manifest.to_hash.should have_key('storyboard_bundling_job')
      @manifest.to_hash['storyboard_bundling_job'].should be_a(Hash)
    end
    
    it "should have a storyboard_bundling_manifest object in the storyboard_bundling_job object" do
      @manifest.to_hash['storyboard_bundling_job'].should have_key('storyboard_bundling_manifest')
      @manifest.to_hash['storyboard_bundling_job']['storyboard_bundling_manifest'].should be_a(Hash)
    end
    
    it "should have a storyboard_url key in the manifest, whose value is the storyboard's URL" do
      @manifest.to_hash['storyboard_bundling_job']['storyboard_bundling_manifest'].should have_key('storyboard_url')
      @manifest.to_hash['storyboard_bundling_job']['storyboard_bundling_manifest']['storyboard_url'].should == @storyboard.url
    end

    describe "when a callback is set" do
      before do
        @manifest.http_callback_url = "http://website.com/callback"
      end
      
      describe "but a format isn't" do
        it "should raise an error" do
          lambda { @manifest.to_hash }.should raise_error(ArgumentError)
        end
      end
      
      describe "and the format is also set" do
        before do
          @manifest.http_callback_format = 'xml'
        end
        
        it "should have an http_callback key in the job object, whose value is the HTTP callback URL" do
          @manifest.to_hash['storyboard_bundling_job'].should have_key('http_callback')
          @manifest.to_hash['storyboard_bundling_job']['http_callback'].should == @manifest.http_callback_url
        end
        
        it "should have an http_callback_format key in the job object, whose value is the callback's format" do
          @manifest.to_hash['storyboard_bundling_job'].should have_key('http_callback_format')
          @manifest.to_hash['storyboard_bundling_job']['http_callback_format'].should == @manifest.http_callback_format
        end
      end
    end
  end
  
end