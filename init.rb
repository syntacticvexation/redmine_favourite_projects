require 'redmine'

Redmine::Plugin.register :redmine_favourite_projects do
  name 'Redmine Favourite Projects plugin'
  author 'Syntactic Vexation'
  description 'This is a plugin for Redmine to provide a list of favourite projects on My Page'
  version '0.0.2'
  url 'https://github.com/syntacticvexation/redmine_favourite_projects'
end

# initialize hook
class FavouritesEditHook < Redmine::Hook::ViewListener
  render_on :view_my_account_contextual, :inline => "| <%= link_to(l('favourite_projects_box'), { :controller => 'favourite_projects', :action => 'index' }) %>"
end
