require_dependency 'application'

class VaporExtension < Radiant::Extension
  version "1.0"
  description "Manage Redirects"
  url "http://saturnflyer.com/"
  
  define_routes do |map|
    map.namespace :admin do |admin|
      admin.resources 'flow_meters'
    end
  end
  
  def activate
    admin.tabs.add "Redirects", "/admin/flow_meters", :after => "Layouts", :visibility => [:admin]
    
    # This will break if the real show_page changes in Radiant
    SiteController.class_eval {
      def show_page
        response.headers.delete('Cache-Control')
    
        url = params[:url]
        if Array === url
          url = url.join('/')
        else
          url = url.to_s
        end
        #this is the added part#
        a_match = FlowMeter.find_by_catch_url(url)
        unless a_match.nil?
          url = a_match.redirect_url
        end
        #end additions#
        if (request.get? || request.head?) and live? and (@cache.response_cached?(url))
          @cache.update_response(url, response, request)
          @performed_render = true
        else
          show_uncached_page(url)
        end
      end
    }
  end
  
  def deactivate
    # admin.tabs.remove "Vapor"
  end
  
end