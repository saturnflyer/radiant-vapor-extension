require_dependency 'application'

class VaporExtension < Radiant::Extension
  version "1.0"
  description "Manage redirects without creating useless pages"
  url "http://saturnflyer.com/"
  
  define_routes do |map|
    map.namespace :admin do |admin|
      admin.resources 'flow_meters'
    end
  end
  
  def activate
    admin.tabs.add "Redirects", "/admin/flow_meters", :after => "Layouts", :visibility => [:admin]
    FlowMeter.initialize_all
    SiteController.send :include, Vapor::ControllerExtensions
  end
  
  def deactivate
    
  end
  
end