require File.dirname(__FILE__) + '/../../spec_helper'

describe SiteController do
  scenario :pages
  
  before(:each) do
    # controller.cache.clear
    @flow_meter = mock_model(FlowMeter)
    FlowMeter.stub!(:all).and_return({})
    @flow_meter = FlowMeter.new(:catch_url => 'this', :redirect_url => 'that')
    @flow_meter.save!
  end
  
  describe "requesting Vapor URL" do
    it "should redirect to the given Redirect URL"
    it "should set the response status to the given Status"
  end
end
