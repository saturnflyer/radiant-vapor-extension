class FlowMeter < ActiveRecord::Base
  before_validation :set_default_status
  
  validates_presence_of :catch_url, :on => :create, :message => "can't be blank"
  validates_presence_of :redirect_url, :on => :create, :message => "can't be blank"
  
  validates_format_of :catch_url, 
    :with => /\A(\/admin){0}/, 
    :on => :create, 
    :message => "cannot catch the admin url", 
    :allow_blank => true
    
  protected
  
  def set_default_status
    status = '307' if status.blank?
  end
end
