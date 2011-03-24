require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Animoto::Assets::Base do
  
  describe "initialization" do
    before do
      @source = 'http://website.com/asset'
      @asset = Animoto::Assets::Base.new @source
    end
    
    it "should set the source from the given source url" do
      @asset.source.should == @source
    end
  end
  
  describe "#to_hash" do
    before do
      @asset = Animoto::Assets::Base.new 'http://website.com/asset'
    end
    
    it "should have a 'source_url' key with the url" do
      @asset.to_hash.should have_key('source_url')
      @asset.to_hash['source_url'].should == @asset.source
    end
  end
  
end