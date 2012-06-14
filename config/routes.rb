RedmineApp::Application.routes.draw do
  match 'favourite_projects/:action', :controller => 'favourite_projects'
end
