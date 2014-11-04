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
	favourites = User.current.ordered_favourite_projects.collect(&:project).compact.uniq
	projects = User.current.memberships.collect(&:project).compact.uniq - favourites
	if projects.any? or favourites.any?
	  options =
	    ("<option value=''>#{ l(:label_jump_to_a_project) }</option>" +
	     "<optgroup label=\"#{ l('favourite_projects.chosen_jump_box.favourite_group')}\">").html_safe
	  options << project_tree_options_for_select(favourites, :selected => @project) do |p|
	    { :value => project_path(:id => p, :jump => current_menu_item) }
	  end 
    
	  options <<
	    ("<optgroup label=\"#{ l('favourite_projects.chosen_jump_box.other_group')}\">").html_safe

	  options << project_tree_options_for_select(projects, :selected => @project) do |p|
	    { :value => project_path(:id => p, :jump => current_menu_item) }
	  end

	  select_tag('project_quick_jump_box', options, :onchange => 'if (this.value != \'\') { window.location = this.value; }')
	end
      else
        render_project_jump_box_without_favourite_projects
      end
    end
  end
end
