class FlowMeter < ActiveRecord::Base
  before_save :set_default_status
  
  validates_presence_of :catch_url, :on => :create, :message => "can't be blank"
  validates_presence_of :redirect_url, :on => :create, :message => "can't be blank"
    
  validate :catch_url_not_restricted
    
  protected
  
  def set_default_status
    self.status = '307' if self.status.blank?
  end
  
  def catch_url_not_restricted
    if catch_url =~ %r{\A\/?(admin)}
      errors.add(:catch_url, 'cannot catch the admin url')
    end
  end
end
