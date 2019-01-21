require 'redmine'

require 'favourite_projects_application_helper_patch'
require 'favourite_projects_menu_patch'
require 'favourite_projects_my_helper_patch'
require 'favourite_projects_project_patch'
require 'favourite_projects_user_patch'

Redmine::Plugin.register :redmine_favourite_projects do
  name 'Redmine Favourite Projects plugin'
  author 'Syntactic Vexation'
  description 'This is a plugin for Redmine to provide a list of favourite projects on My Page, Top Menu or Project Jumplist'
  version '1.0'
  requires_redmine version_or_higher: '4.0'
  url 'https://github.com/syntacticvexation/redmine_favourite_projects'

  
  settings :default => {
    'showDetailedProjectView' => true,
    'modifyProjectJumpList' => false,
    'modifyTopMenu' => false,
    'allowUserOverride' => true
    },
    :partial => 'redmine_favourite_projects'
end

# initialize hook
class FavouritesEditHook < Redmine::Hook::ViewListener
  render_on :view_my_account_contextual, :inline => "| <%= link_to(l('favourite_projects_box'), { :controller => 'favourite_projects', :action => 'index' }) %>"
end
