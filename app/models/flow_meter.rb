class FlowMeter < ActiveRecord::Base
  class DataMismatch < StandardError; end
  
  include Vaporizer
  
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
    path = self[att]
    if path == '/'
      '/'
    elsif path.match('^https?://')
      path
    else
      radiant_path(self.cleaned_up_path(path))
    end
  end
  
  [:catch_url, :redirect_url].each do |att|
    define_method "#{att.to_s}_for_display" do
      display_url(att)
    end
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
  
  def self.find_for_page(page)
    if Radiant::Config['vapor.use_regexp'] == 'true'
      match = catch_url_match_with_regexp(page.url)
    else
      match = catch_url_match(page.url)
    end
    match = self.find_by_catch_url(match) if match
  end
  
  def self.redirect_url_for_page(page)
    if Radiant::Config['vapor.use_regexp'] == true
      FlowMeter.match_for_page_with_regexp(page).to_s
    else
      FlowMeter.match_for_page(page).to_s
    end
  end
  
  protected
  
  def self.match_for_page(page)    
    url = page.url.sub(/\/$/, '') unless url == '/' # drop the trailing slash for lookup
    url = url.sub(/^\//, '') unless url == '/'
    a_match = FlowMeter.all[url]
    unless a_match.nil?
      redirect_url = a_match[0]
      redirect_url = '/' + redirect_url unless redirect_url.match('^https?://') || redirect_url == '/'
      return redirect_url
    end
    nil
  end
  
  def self.match_for_page_with_regexp(page)
    redirect_url = nil
    FlowMeter.all.sort.reverse.each do |meter|
      key = meter[0]
      value = meter[1]
      if (match = url.match(Regexp.new('^'+key)))
        redirect_url = match_substitute(value[0], match)
        return redirect_url
        break
      end
    end
    redirect_url
  end
  
  def set_default_status
    self.status = '307 Temporarily Moved' if self.status.blank?
  end
  
  def clean_catch_url
    clean_url(:catch_url) unless catch_url.blank?
  end
  
  def clean_redirect_url
    clean_url(:redirect_url) unless redirect_url.blank? or redirect_url.match('^https?://')
  end
  
  def clean_url(att)
    if !self[att].blank? and !self[att].nil?
      path = self[att]
      self.update_attribute(att, self.cleaned_up_path(path))
    end
  end
end
