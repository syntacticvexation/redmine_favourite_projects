require_dependency 'application_helper'

module FavouriteProjectsApplicationHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      alias_method_chain :render_project_jump_box, :favourite_projects
    end
  end
  
  module InstanceMethods
    # hacked from ApplicationHelper's render _project_jump_box
    def render_project_jump_box_with_favourite_projects
      if Setting.plugin_redmine_favourite_projects['modifyProjectJumpList']
	return unless User.current.logged?
	favourites = FavouriteProject.find(:all,:conditions => ["user_id = ?", User.current.id],:include => :project, :order => 'projects.name').collect(&:project).compact.uniq
	projects = User.current.memberships.collect(&:project).compact.uniq - favourites
	if projects.any? or favourites.any?
	  s = '<select onchange="if (this.value != \'\') { window.location = this.value; }">' +
		"<option value=''>#{ l(:label_jump_to_a_project) }</option>" +
		'<option value="" disabled="disabled">---'+ l(:favourite_projects_box) + '---</option>'
	  s << project_tree_options_for_select(favourites, :selected => @fav) do |p|
	    { :value => url_for(:controller => 'projects', :action => 'show', :id => p, :jump => current_menu_item) }
	  end
	  s << '<option value="" disabled="disabled">---</option>'
	  s << project_tree_options_for_select(projects, :selected => @project) do |p|
	    { :value => url_for(:controller => 'projects', :action => 'show', :id => p, :jump => current_menu_item) }
	  end
	  s << '</select>'
	  s
	end
      else
        render_project_jump_box_without_favourite_projects
      end
    end
  end
end
