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
        if (match = url.match(Regexp.new('^'+key)))
          redirect_url = match_substitute(value[0], match)
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

private
  
  def match_substitute(string, match)
    string.gsub(/\$([`&0-9'$])/) do |sub|
      case $1
      when "`": match.pre_match
      when "&": match[0]
      when "0".."9": puts $1.to_i; match[$1.to_i]
      when "'": match.post_match
      when "$": '$'
      end
    end
  end
end
