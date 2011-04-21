require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Animoto::Assets::Song do
  
  describe "initialization" do
    before do
      @song = Animoto::Assets::Song.new 'http://website.com/song.mp3',
        :start_time => 30.0, :duration => 90.0, :title => "Hooray for Dolphins!", :artist => "Some Chick with Bangs"
    end
    
    it "should set the source to the given url" do
      @song.source.should == 'http://website.com/song.mp3'
    end
    
    it "should set the start time to the given time" do
      @song.start_time.should == 30.0
    end
    
    it "should set the duration to the given length" do
      @song.duration.should == 90.0
    end
    
    it "should set the title to the given string" do
      @song.title.should == 'Hooray for Dolphins!'
    end
    
    it "should set the artist to the given string" do
      @song.artist.should == 'Some Chick with Bangs'
    end
  end

  describe "#to_hash" do
    before do
      @song = Animoto::Assets::Song.new 'http://website.com/song.mp3'
    end
    
    it "should have a 'source_url' key with the url" do
      @song.to_hash.should have_key('source_url')
      @song.to_hash['source_url'].should == @song.source
    end
    
    describe "if a start time was specified" do
      before do
        @song.start_time = 30.2
      end
      
      it "should have a 'start_time' key with the start time" do
        @song.to_hash.should have_key('start_time')
        @song.to_hash['start_time'].should == @song.start_time
      end
    end
    
    describe "if a duration was specified" do
      before do
        @song.duration = 300
      end
      
      it "should have a 'duration' key with the duration" do
        @song.to_hash.should have_key('duration')
        @song.to_hash['duration'].should == @song.duration
      end
    end
    
    describe "if a title was specified" do
      before do
        @song.title = 'Hooray for Dolphins!'
      end
      
      it "should have a 'title' key with the title" do
        @song.to_hash.should have_key('title')
        @song.to_hash['title'].should == @song.title
      end
    end
    
    describe "if an artist was specified do" do
      before do
        @song.artist = 'Some Chick with Bangs'
      end
      
      it "should have an 'artist' key with the artist" do
        @song.to_hash.should have_key('artist')
        @song.to_hash['artist'].should == @song.artist
      end
    end
  end
end
