require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Animoto::Resources::Video do
  
  it "should have content type 'application/vnd.animoto.video'" do
    Animoto::Resources::Video.content_type.should == 'video'
  end
  
  it "should have payload key 'video'" do
    Animoto::Resources::Video.payload_key.should == 'video'
  end

  describe "initialization" do
    before do
      @body = {
        'response' => {
          'status' => {
            'code' => 200
          },
          'payload' => {
            'video' => {
              'metadata' => {
                'rendering_parameters' => {
                  'format' => 'h264',
                  'framerate' => 30,
                  'resolution' => '720p'
                }
              },
              'links' => {
                'self' => 'https://platform.animoto.com/videos/1',
                'file' => 'http://storage.com/videos/1.mp4',
                'cover_image' => 'http://storage.com/videos/1/cover_image.jpg',
                'storyboard' => 'https://platform.animoto.com/storyboards/1'
              }
            }
          }
        }
      }
      @video = Animoto::Resources::Video.load(@body)
    end
    
    it "should set its url from the 'self' link given" do
      @video.url.should == 'https://platform.animoto.com/videos/1'
    end
    
    it "should set its download url from the 'file' link given" do
      @video.download_url.should == 'http://storage.com/videos/1.mp4'
    end
    
    it "should set its cover image url from the 'cover_image' link given" do
      @video.cover_image_url.should == 'http://storage.com/videos/1/cover_image.jpg'
    end
    
    it "should set its storyboard url from the 'storyboard_url' given" do
      @video.storyboard_url.should == 'https://platform.animoto.com/storyboards/1'
    end
    
    it "should set its storyboard from its storyboard url" do
      @video.storyboard.url.should == 'https://platform.animoto.com/storyboards/1'
    end
    
    it "should set its format from the format given" do
      @video.format.should == 'h264'
    end
    
    it "should set its framerate from the framerate given" do
      @video.framerate.should == 30
    end
    
    it "should set its resolution from the resolution given" do
      @video.resolution.should == '720p'
    end
  end
  
end
