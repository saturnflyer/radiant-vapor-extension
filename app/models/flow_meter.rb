class FlowMeter < ActiveRecord::Base
  class DataMismatch < StandardError; end
  
  before_save :set_default_status
  after_validation :clean_catch_url
  after_validation :clean_redirect_url
  after_save :initialize_all
  after_destroy :initialize_all
  
  validates_presence_of :catch_url, :on => :create, :message => "can't be blank"
  validates_presence_of :redirect_url, :on => :create, :message => "can't be blank"
  
  validates_uniqueness_of :catch_url
    
  validate :catch_url_not_restricted
  validate :redirect_url_not_restricted
  
  @@all = {}
  
  def self.all
    @@all
  end
  
  def all
    @@all
  end
  
  def all=(all_hash)
    @@all = all_hash
  end
  
  def initialize_all
    FlowMeter.initialize_all
  end
  
  def self.initialize_all
    @@all = {}
    FlowMeter.find(:all).each do |fm|
      @@all[fm[:catch_url]] = [fm[:redirect_url], fm[:status]]
    end
  end
  
  def display_url(att)
    self[att] == '/' ? cleaned_up_url(att) : "/#{cleaned_up_url(att)}"
  end
  
  [:catch_url, :redirect_url].each do |att|
    define_method "#{att.to_s}_for_display" do
      display_url(att)
    end
  end
  
  def cleaned_up_url(att)
    new_att = self[att].gsub(%r{//+},'/').gsub(%r{\s+},'')
    new_att.gsub!(%r{^/},'') unless new_att == '/'
    new_att
  end
  
  def catch_url_not_restricted
    if catch_url =~ %r{\A\/?(admin)}
      errors.add(:catch_url, 'cannot catch the admin url')
    end
  end
  
  def redirect_url_not_restricted
    if catch_url == redirect_url
      raise DataMismatch, "Catch URL and Redirect URL may not be the same."
    end
  end
  
  protected
  
  def set_default_status
    self.status = '307' if self.status.blank?
  end
  
  def clean_catch_url
    clean_url(:catch_url) unless catch_url.blank?
  end
  
  def clean_redirect_url
    clean_url(:redirect_url) unless redirect_url.blank? or redirect_url.match('http://')
  end
  
  def clean_url(att)
    if !self[att].blank? and !self[att].nil?
      self.update_attribute(att, cleaned_up_url(att))
    end
  end
end
