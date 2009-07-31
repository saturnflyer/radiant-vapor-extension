require_dependency 'application_controller'

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
    FlowMeter.initialize_all if ActiveRecord::Base.connection.tables.include?('flow_meters')
    SiteController.send :include, Vapor::ControllerExtensions
    
    if admin.respond_to? :help
      admin.help.index.add :page_details, 'slug_redirect', :after => 'slug'
    end
  end
  
  def deactivate
    
  end
  
end
