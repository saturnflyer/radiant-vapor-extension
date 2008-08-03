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
    
    a_match = FlowMeter.find_by_catch_url(url)
    unless a_match.nil?
      url = a_match.redirect_url
      if (request.get? || request.head?) and live? and (@cache.response_cached?(url))
        @cache.update_response(url, response, request)
        @performed_render = true
      else
        show_uncached_page(url)
      end
    else
      show_page_without_vapor
    end
  end
end