require File.dirname(__FILE__) + '/../../spec_helper'

describe Animoto::HTTPEngines::Base do  
  describe "making a request" do
    before do
      @engine = Animoto::HTTPEngines::Base.new
    end
    
    it "should raise an implementation error" do
      lambda { @engine.request(:get, "http://www.example.com/thing") }.should raise_error(Animoto::AbstractMethodError)
    end
  end
  
end