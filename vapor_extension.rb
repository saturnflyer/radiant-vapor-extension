require_dependency 'application_controller'

class VaporExtension < Radiant::Extension
  version "#{File.read(File.expand_path(File.dirname(__FILE__)) + '/VERSION')}"
  description "Manage redirects without creating useless pages"
  url "http://saturnflyer.com/"
    
  def activate
    unless respond_to?(:tab)
      admin.tabs.add "Redirects", "/admin/flow_meters", :after => "Layouts", :visibility => [:admin]
    else
      tab 'Content' do
        add_item 'Redirects', '/admin/flow_meters'
      end
    end
    FlowMeter.initialize_all if ActiveRecord::Base.connection.tables.include?('flow_meters')
    
    Page.class_eval { include PageVapor }
    
    admin.pages.edit.add :form, 'vapor_details', :before => 'edit_title'
    
    if admin.respond_to? :help
      admin.help.index.add :page_details, 'slug_redirect', :after => 'slug'
    end
    
    Admin::PagesController.class_eval {
      helper Admin::PageNodeAlterationsHelper
    }
  end
  
  def deactivate
    
  end
  
end
