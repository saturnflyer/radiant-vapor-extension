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
  
  it "should set '307' as the status if created with no status" do
    @flow_meter.save!
    @flow_meter.status.should == '307'
  end
  
  it "should err with a catch_url beginning with 'admin'" do
    @flow_meter.catch_url = "admin"
    @flow_meter.valid?
    @flow_meter.errors.on(:catch_url).should match(/cannot catch the admin url/)
  end
  
  it "should err with a catch_url beginning with '/admin'" do
    @flow_meter.catch_url = "/admin"
    @flow_meter.valid?
    @flow_meter.errors.on(:catch_url).should match(/cannot catch the admin url/)
  end
  
  it "should err with a non-unique catch_url" do
    @flow_meter.save
    @flow_meter2 = FlowMeter.new(:catch_url => @flow_meter.catch_url, :redirect_url => '/other')
    @flow_meter2.valid?
    @flow_meter2.errors.on(:catch_url).should match(/has already been taken/)
  end
  
  it "should remove the first character from catch_url beginning with a slash" do
    @flow_meter.save
    @flow_meter.catch_url.should == 'stuff'
  end
  
  it "should remove the first character from redirect_url beginning with a slash" do
    @flow_meter.save
    @flow_meter.redirect_url.should == 'things'
  end
  
  it "should remove consecutive slashes from the catch_url before saving" do
    @flow_meter.catch_url = "///slasher"
    @flow_meter.save
    @flow_meter.catch_url.should == 'slasher'
  end
  
  it "should remove consecutive slashes from the redirect_url before saving" do
    @flow_meter.redirect_url = "///chop"
    @flow_meter.save
    @flow_meter.redirect_url.should == 'chop'
  end
  
  it "should remove all whitespace from catch_url before saving" do
    @flow_meter.catch_url = "hello there"
    @flow_meter.save
    @flow_meter.catch_url.should == 'hellothere'
  end
  
  it "should remove all whitespace from redirect_url before saving" do
    @flow_meter.redirect_url = "how are you"
    @flow_meter.save
    @flow_meter.redirect_url.should == 'howareyou'
  end
  
  it "should allow '/' as the redirect_url" do
    @flow_meter.redirect_url = "/"
    @flow_meter.save
    @flow_meter.redirect_url.should == '/'
  end

  it "should provide a catch_url_for_display which includes a leading slash" do
    @flow_meter.catch_url_for_display.should == '/stuff'
  end
  
  it "should provide a redirect_url_for_display which includes a leading slash" do
    @flow_meter.redirect_url_for_display.should == '/things'
  end

  it "should err with 'Catch URL and Redirect URL may not be the same.' when given a catch_url that matches the redirect_url" do
    @flow_meter.redirect_url = "/stuff"
    lambda {@flow_meter.save!}.should raise_error(FlowMeter::DataMismatch, "Catch URL and Redirect URL may not be the same.")
  end
end