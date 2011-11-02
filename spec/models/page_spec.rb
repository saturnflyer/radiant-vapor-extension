require File.dirname(__FILE__) + '/../spec_helper'

describe Page do
  dataset :users_and_pages
  
  before(:each) do
    @redirector = FlowMeter.create!({:catch_url => '/first', :redirect_url => '/another', :status => '307'})
  end
  
  describe 'flow_meter' do
    it "should return nil if none is found" do
      pages(:home).flow_meter.should be_nil
    end
    it "should return the first flow_meter found which matches the page url" do
      pages(:first).flow_meter.should == @redirector
    end
    it "should redirect '/' to '/another'" do
      @redirector[:catch_url] = "/"
      @redirector.save
      pages(:home).flow_meter.should == @redirector
    end
  end
end
