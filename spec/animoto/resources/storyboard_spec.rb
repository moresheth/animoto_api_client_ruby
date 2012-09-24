require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Animoto::Resources::Storyboard do

  it "should have content type 'application/vnd.animoto.storyboard'" do
    Animoto::Resources::Storyboard.content_type.should == 'storyboard'
  end
  
  it "should have payload key 'storyboard'" do
    Animoto::Resources::Storyboard.payload_key.should == 'storyboard'
  end

  describe "initialization" do
    before do
      @body = {
        'response' => {
          'status' => {
            'code' => 200
          },
          'payload' => {
            'storyboard' => {
              'metadata' => {
                'duration' => 300.0,
                'visuals' => [
                  "https://foo.com/1",
                  "https://foo.com/2"
                ]
              },
              'links' => {
                'self' => 'https://platform.animoto.com/storyboards/1',
                'preview' => 'http://storage.com/previews/1.mp4'
              }
            }
          }
        }
      }
      @storyboard = Animoto::Resources::Storyboard.load(@body)
    end
    
    it "should set its url from the 'self' link given" do
      @storyboard.url.should == 'https://platform.animoto.com/storyboards/1'
    end
    
    it "should set its preview url from the 'preview' link given" do
      @storyboard.preview_url.should == 'http://storage.com/previews/1.mp4'
    end
    
    it "should set its duration from the 'duration' metadata given" do
      @storyboard.duration.should == 300.0
    end
    
    it "should set its visuals count from the visuals_count metadata given" do
      @storyboard.visuals_count.should == 2
    end
  end
  
end
