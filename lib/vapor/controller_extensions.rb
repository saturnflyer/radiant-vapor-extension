module Vapor::ControllerExtensions
  def self.included(base)
    base.class_eval { alias_method_chain :show_page, :vapor }
  end

  def show_page_with_vapor
    url = params[:url]
    if Array === url
      url = url.join('/')
    else
      url = url.to_s
    end
    a_match = FlowMeter.all[url]
    unless a_match.nil?
      url = a_match[0]
      location = url.match('http://') ? url : url_for(:controller => 'site', :action => 'show_page', :url => url)
      redirect_to location, :status => a_match[1].to_s and return
    else
      show_page_without_vapor
    end
  end
end