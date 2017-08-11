require_dependency 'application_helper'

module FavouriteProjectsApplicationHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      alias_method_chain :render_project_jump_box, :favourite_projects
      alias_method :calculated_favourite_projects_settings, :calculated_favourite_projects_settings
    end
  end
  
  module InstanceMethods
    # hacked from ApplicationHelper's render _project_jump_box
    def render_project_jump_box_with_favourite_projects
      if calculated_favourite_projects_settings['modifyProjectJumpList']
		    return unless User.current.logged?
		    favourites = User.current.ordered_favourite_projects.collect(&:project).compact.uniq
		    projects = projects_for_jump_box(User.current) - favourites

        if @project && @project.persisted?
          text = @project.name_was
        end
        text ||= l(:label_jump_to_a_project)
        url = autocomplete_projects_path(:format => 'js', :jump => current_menu_item)

        trigger = content_tag('span', text, :class => 'drdn-trigger')
        q = text_field_tag('q', '', :id => 'projects-quick-search', :class => 'autocomplete', :data => {:automcomplete_url => url}, :autocomplete => 'off')
        all = link_to(l(:label_project_all), projects_path(:jump => current_menu_item), :class => (@project.nil? && controller.class.main_menu ? 'selected' : nil))
        content = content_tag('div',
              content_tag('div', q, :class => 'quick-search') +
              content_tag('div', render_projects_for_jump_box(favourites, @project), :class => 'drdn-items projects selection') +
              content_tag('div', render_projects_for_jump_box(projects, @project), :class => 'drdn-items projects selection') +
              content_tag('div', all, :class => 'drdn-items all-projects selection'),
            :class => 'drdn-content'
          )

        content_tag('div', trigger + content, :id => "project-jump", :class => "drdn")
      else
        render_project_jump_box_without_favourite_projects
      end
    end

    def calculated_favourite_projects_settings
    	# the administrator allows the user to override settings and the user has overriden them
    	if Setting.plugin_redmine_favourite_projects['allowUserOverride'] and not User.current.pref.nil? and 
    	  not User.current.pref[:redmine_favourite_projects].nil? and 
    	  User.current.pref[:redmine_favourite_projects].member? :user_overriden
    		return User.current.pref[:redmine_favourite_projects]
    	end

    	return Setting.plugin_redmine_favourite_projects
    end
  end
end
