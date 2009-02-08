module Vapor::ControllerExtensions
  def self.included(base)
    base.class_eval { before_filter :apply_flow_meters }
  end
  
  def apply_flow_meters
    url = params[:url]
    if Array === url
      url = url.join('/')
    else
      url = url.to_s
    end
    if config['vapor.use_regexp'] == 'true'
      FlowMeter.all.sort.reverse.each do |meter|
        key = meter[0]
        value = meter[1]
        if url.match(Regexp.new('^'+key))          
          redirect_url = value[0]
          location = redirect_url.match('http://') ? redirect_url : url_for(:controller => 'site', :action => 'show_page', :url => redirect_url)
          redirect_to CGI.unescape(location), :status => value[1].to_s and return
        end
      end
    else
      a_match = FlowMeter.all[url]
      unless a_match.nil?
        redirect_url = a_match[0]
        location = url.match('http://') ? redirect_url : url_for(:controller => 'site', :action => 'show_page', :url => redirect_url)
        redirect_to CGI.unescape(location), :status => a_match[1].to_s and return
      end
    end
  end

end