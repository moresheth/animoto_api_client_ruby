require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe Animoto::Resources::Jobs::StoryboardBundling do

  it "should have endpoint '/jobs/storyboard_bundling'" do
    Animoto::Resources::Jobs::StoryboardBundling.endpoint.should == '/jobs/storyboard_bundling'
  end
  
  it "should have content type 'application/vnd.animoto.storyboard_bundling_job'" do
    Animoto::Resources::Jobs::StoryboardBundling.content_type.should == 'storyboard_bundling_job'
  end
  
  it "should have payload key 'storyboard_bundling_job'" do
    Animoto::Resources::Jobs::StoryboardBundling.payload_key.should == 'storyboard_bundling_job'
  end

  describe "loading from a response body" do
    before do
      @body = {
        'response' => {
          'status' => {
            'code' => 200
          },
          'payload' => {
            'storyboard_bundling_job' => {
              'state' => 'completed',
              'links' => {
                'self' => 'https://platform.animoto.com/jobs/storyboard_bundling/1',
                'bundle' => 'http://some-kind-of-storage-service.com/animoto-bundles/1'
              }
            }
          }
        }
      }
      @job = Animoto::Resources::Jobs::StoryboardBundling.load @body
    end
    
    it "should set the bundle_url from the body" do
      @job.bundle_url.should == "http://some-kind-of-storage-service.com/animoto-bundles/1"
    end
  end

end