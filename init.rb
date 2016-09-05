require 'redmine'

# Including dispatcher.rb in case of Rails 2.x
require 'dispatcher' unless Rails::VERSION::MAJOR >= 3

if Rails::VERSION::MAJOR >= 3
  RedmineApp::Application.config.after_initialize do
    require_dependency 'application_helper'
    require_dependency 'favourite_projects_searchbox_hook_listener'

    unless Project.included_modules.include?(FavouriteProjectsProjectPatch)
      Project.send(:include, FavouriteProjectsProjectPatch)
    end

    unless User.included_modules.include?(FavouriteProjectsUserPatch)
      User.send(:include, FavouriteProjectsUserPatch)
    end
    
    unless ApplicationHelper.included_modules.include?(FavouriteProjectsApplicationHelperPatch)
      ApplicationHelper.send(:include, FavouriteProjectsApplicationHelperPatch)
    end
    
    unless MyHelper.included_modules.include?(FavouriteProjectsMyHelperPatch)
      MyHelper.send(:include, FavouriteProjectsMyHelperPatch)
    end
  end
else
  Dispatcher.to_prepare :redmine_favourite_projects do
    require_dependency 'application_helper'

    unless Project.included_modules.include?(FavouriteProjectsProjectPatch)
      Project.send(:include, FavouriteProjectsProjectPatch)
    end

    unless User.included_modules.include?(FavouriteProjectsUserPatch)
      User.send(:include, FavouriteProjectsUserPatch)
    end    

    unless ApplicationHelper.included_modules.include?(FavouriteProjectsApplicationHelperPatch)
      ApplicationHelper.send(:include, FavouriteProjectsApplicationHelperPatch)
    end

    unless MyHelper.included_modules.include?(FavouriteProjectsMyHelperPatch)
      MyHelper.send(:include, FavouriteProjectsMyHelperPatch)
    end
  end
end

Redmine::Plugin.register :redmine_favourite_projects do
  name 'Redmine Favourite Projects plugin'
  author 'Syntactic Vexation'
  description 'This is a plugin for Redmine to provide a list of favourite projects on My Page, Top Menu or Project Jumplist'
  version '0.7.1'
  url 'https://github.com/syntacticvexation/redmine_favourite_projects'

  
  settings :default => {
    'showDetailedProjectView' => true,
    'modifyProjectJumpList' => false,
    'modifyTopMenu' => false
    },
    :partial => 'redmine_favourite_projects'
  
  menu :top_menu, :favourite_menu, '',
  {
    :caption => '',
    :html => { :id => 'favourite-menu' },
    :param => :project_id,
    :if => Proc.new { User.current.logged? and Setting.plugin_redmine_favourite_projects['modifyTopMenu'] }
  }
end

# initialize hook
class FavouritesEditHook < Redmine::Hook::ViewListener
  render_on :view_layouts_base_body_bottom, :partial => 'favourite_projects/update_menu'
  render_on :view_my_account_contextual, :inline => "| <%= link_to(l('favourite_projects_box'), { :controller => 'favourite_projects', :action => 'index' }) %>"
end
