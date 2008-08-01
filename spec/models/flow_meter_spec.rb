require File.dirname(__FILE__) + '/../spec_helper'

describe FlowMeter do
  before(:each) do
    @flow_meter = FlowMeter.new(:catch_url => "/stuff", :redirect_url => '/things', :status => '')
  end

  it "should err without a catch_url" do
    @flow_meter.catch_url = nil
    @flow_meter.valid?
    @flow_meter.errors.on(:catch_url).should match(/can't be blank/)
  end

  it "should err without a redirect_url" do
    @flow_meter.redirect_url = nil
    @flow_meter.valid?
    @flow_meter.errors.on(:redirect_url).should match(/can't be blank/)
  end
  
  it "should set '307' as the default status" do
    @flow_meter.status.should == "307"
  end
  
  it "should set '307' as the status if created with no status" do
    @flow_meter.save!
    @flow_meter.status.should == '307'
  end
  
  it "should err with a catch_url beginning with '/admin'" do
    @flow_meter.catch_url = "/admin"
    @flow_meter.valid?
    @flow_meter.errors.on(:catch_url).should match(/cannot catch the admin url/)
  end
end
