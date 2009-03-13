require File.dirname(__FILE__) + '/../spec_helper'

describe SiteController do
  scenario :users_and_pages
  
  before(:each) do
    login_as :admin
    controller.cache.clear
    @flow_meters = {"this" => ["that", "307"], "this2" => ["blog/2005/01/01/some-post", "307"], "this/(.+)" => ["http://that.org/$1", "301"]}
    @flow_meter = FlowMeter.create!(:catch_url => 'this', :redirect_url => 'that')
    @flow_meter = FlowMeter.create!(:catch_url => 'this2', :redirect_url => 'blog/2005/01/01/some-post')    
    @flow_meter = FlowMeter.create!(:catch_url => 'this/(.+)', :redirect_url => 'http://that.org/$1')
    FlowMeter.initialize_all
    
    # @wildcard = mock_model(FlowMeter)
    FlowMeter.stub!(:all).and_return(@flow_meters)
  end
  
  describe "requesting Vapor URL" do
    before(:each) do
      controller.config['vapor.use_regexp'] = nil
    end

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
  
  describe "requesting Vapor URL when use_regexp is on" do
    before(:each) do
      controller.config['vapor.use_regexp'] = 'true'
    end

    it "should catch URLs that begin with the regexp" do
      get :show_page, :url => 'this/page'
      response.redirect?.should == true
    end
    it "should do substitutions in the redirect URL" do
      get :show_page, :url => 'this/page'
      response.should redirect_to('http://that.org/page')
    end
  end
end
