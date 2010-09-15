ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.resources 'flow_meters', :only => [:index, :create, :destroy]
  end
end