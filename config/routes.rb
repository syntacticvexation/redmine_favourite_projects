ActionController::Routing::Routes.draw do |map|
  map.resources :favourite_projects, :controller => 'favourite_projects', :path_prefix => 'my'
end