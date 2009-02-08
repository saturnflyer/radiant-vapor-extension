require File.dirname(__FILE__) + '/../spec_helper'

describe SiteController do
  scenario :users_and_pages
  
  before(:each) do
    login_as :admin
    controller.cache.clear
    @flow_meters = {"this" => ["that", "307"], "this2" => ["blog/2005/01/01/some-post", "307"]}
    @flow_meter = FlowMeter.create!(:catch_url => 'this', :redirect_url => 'that')
    @flow_meter = FlowMeter.create!(:catch_url => 'this2', :redirect_url => 'blog/2005/01/01/some-post')    
    FlowMeter.initialize_all
    
    # @wildcard = mock_model(FlowMeter)
    FlowMeter.stub!(:all).and_return(@flow_meters)
  end
  
  describe "requesting Vapor URL" do
    it "should redirect to the given Redirect URL" do
      get :show_page, :url => 'this'
      response.should be_redirect
    end
    it "should redirect to the given Redirect URL" do
      get :show_page, :url => 'this2'
      response.should redirect_to('blog/2005/01/01/some-post')
    end    
    it "should set the response status to the given Status" do
      get :show_page, :url => 'this'
      response.headers["Status"].should =~ /307/
    end
  end
end
