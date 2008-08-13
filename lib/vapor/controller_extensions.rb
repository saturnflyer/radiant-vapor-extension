module Vapor::ControllerExtensions
  def self.included(base)
    base.class_eval { alias_method_chain :show_page, :vapor }
  end

  def show_page_with_vapor
    response.headers.delete('Cache-Control')

    url = params[:url]
    if Array === url
      url = url.join('/')
    else
      url = url.to_s
    end
    
    a_match = FlowMeter.all[url]
    unless a_match.blank?
      url = a_match[0]
      if (request.get? || request.head?) and live? and (@cache.response_cached?(url))
        if url.match('http://')
          redirect_to url
        else
          redirect_to site_url(url)
        end
      else
        show_uncached_page(url)
      end
    else
      show_page_without_vapor
    end
  end
end