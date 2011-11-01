require 'redmine'

# Patches to the Redmine core
require 'dispatcher'

Dispatcher.to_prepare :redmine_favourite_projects do
  require_dependency 'application_helper'
  ApplicationHelper.send(:include, FavouriteProjectsApplicationHelperPatch) unless ApplicationHelper.included_modules.include?(FavouriteProjectsApplicationHelperPatch)
end

Redmine::Plugin.register :redmine_favourite_projects do
  name 'Redmine Favourite Projects plugin'
  author 'Syntactic Vexation'
  description 'This is a plugin for Redmine to provide a list of favourite projects on My Page'
  version '0.2.0'
  url 'https://github.com/syntacticvexation/redmine_favourite_projects'

  
  settings :default => {
    'modifyProjectJumpList' => false
    },
    :partial => 'redmine_favourite_projects'
  
  menu :top_menu, :favourite_menu, '',
  {
    :caption => '',
    :html => { :id => 'favourite-menu' },
    :param => :project_id,
    :if => Proc.new { User.current.logged? }
  }
end

# initialize hook
class FavouritesEditHook < Redmine::Hook::ViewListener
  render_on :view_layouts_base_body_bottom, :partial => 'favourite_projects/update_menu'
  render_on :view_my_account_contextual, :inline => "| <%= link_to(l('favourite_projects_box'), { :controller => 'favourite_projects', :action => 'index' }) %>"
end
