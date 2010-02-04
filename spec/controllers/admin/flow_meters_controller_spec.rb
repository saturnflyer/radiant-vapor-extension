require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::FlowMetersController do
  dataset :users
  
  before(:each) do
    login_as :admin
  end
  
  describe "/admin/flow_meters with GET" do
    before(:each) do
      @flow_meter = mock_model(FlowMeter)
      @new_flow_meter = mock_model(FlowMeter)
      @flow_meters = [@flow_meter]
      FlowMeter.stub!(:find).with(:all).and_return(@flow_meters)
      FlowMeter.stub!(:new).and_return(@new_flow_meter)
      get :index
    end
    
    it "should render the admin/index template" do
      response.should render_template('index')
    end
    
    it "should get all flow_meters" do
      assigns[:flow_meters].should == [@flow_meter]
    end
    
    it "should get a new flow_meter" do
      assigns[:flow_meter].should == @new_flow_meter
    end
  end
  describe "/admin/flow_meters with valid POST" do
    before(:each) do
      @flow_meter = FlowMeter.create!(:catch_url => 'this', :redirect_url => 'that', :status => '302 Found')
      @flow_meter_count = FlowMeter.count
      post :create, :flow_meter => {:catch_url => 'other', :redirect_url => 'that'}
    end
    
    it "should increase the flow_meter_count by 1" do
      FlowMeter.count.should > @flow_meter_count
    end
    
    it "should redirect to the index" do
      response.should redirect_to('/admin/flow_meters')
    end
  end
  describe "/admin/flow_meters with invalid POST" do
    before(:each) do
      post :create, :flow_meter => {:catch_url => 'admin', :redirect_url => 'that'}
    end
    
    it "should assign the error message to the flash" do
      flash[:error].should_not be_blank
    end
    
    it "should redirect to the index" do
      response.should redirect_to('/admin/flow_meters')
    end
  end
  describe "/admin/flow_meters/:id with DELETE" do
    before(:each) do
      @flow_meter = FlowMeter.create!(:catch_url => 'this', :redirect_url => 'that', :status => '302 Found')
    end
    
    it "should find the flow_meter" do
      FlowMeter.stub!(:find).with(:all).and_return([@flow_meter])
      FlowMeter.should_receive(:find).with(@flow_meter.id.to_s).and_return(@flow_meter)
      delete :destroy, :id => @flow_meter.id
    end
    it "should reduce the flow_meter count by 1" do
      @flow_meter_count = FlowMeter.count
      delete :destroy, :id => @flow_meter.id
      FlowMeter.count.should < @flow_meter_count
    end
    it "should redirect to the index" do
      delete :destroy, :id => @flow_meter.id
      response.should redirect_to('/admin/flow_meters')
    end
  end
end
