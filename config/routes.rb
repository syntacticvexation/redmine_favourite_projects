ActionController::Routing::Routes.draw do |map|
    map.connect 'favourite_projects/:action', :controller => 'favourite_projects'
end