require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe Animoto::Resources::Jobs::StoryboardUnbundling do

  it "should have endpoint /jobs/storyboard_unbundling" do
    Animoto::Resources::Jobs::StoryboardUnbundling.endpoint.should == '/jobs/storyboard_unbundling'
  end
  
  it "should have content type 'application/vnd.animoto.storyboard_unbundling_job" do
    Animoto::Resources::Jobs::StoryboardUnbundling.content_type.should == 'storyboard_unbundling_job'
  end
  
  it "should have payload key storyboard_unbundling_job" do
    Animoto::Resources::Jobs::StoryboardUnbundling.payload_key.should == 'storyboard_unbundling_job'
  end

  describe "loading from a response body" do
    before do
      @body = {
        'response' => {
          'status' => {
            'code' => 200
          },
          'payload' => {
            'storyboard_unbundling_job' => {
              'state' => 'completed',
              'links' => {
                'self' => 'https://platform.animoto.com/jobs/storyboard_unbundling/1',
                'storyboard' => 'https://platform.animoto.com/storyboards/1'
              }              
            }
          }
        }
      }
      @job = Animoto::Resources::Jobs::StoryboardUnbundling.load @body
    end
    
    it "should set the storyboard_url from the body" do
      @job.storyboard_url.should == "https://platform.animoto.com/storyboards/1"
    end
    
    it "should create a storyboard from the storyboard url" do
      @job.storyboard.should be_a(Animoto::Resources::Storyboard)
      @job.storyboard_url.should == @job.storyboard.url
    end
  end

end