if Rails::VERSION::MAJOR >= 3
  RedmineApp::Application.routes.draw do
    match 'favourite_projects/:action', :controller => 'favourite_projects', :via => [:get, :post]
  end
else
  ActionController::Routing::Routes.draw do |map|
    map.connect 'favourite_projects/:action', :controller => 'favourite_projects'
  end
end
