class FavouriteProjectsController < ApplicationController
  unloadable

  def index
    @user = User.current
    @settings = @user.pref[:redmine_favourite_projects]

    if @settings.nil? or not @settings.member? :user_overriden
      @settings = Setting['plugin_redmine_favourite_projects']
    end
    
    @favourite_projects = User.current.ordered_favourite_projects
    @available_projects = Project.find_by_sql("select projects.* FROM projects, members WHERE project_id = projects.id and user_id = '#{User.current.id}' and project_id NOT IN (select project_id from favourite_projects where user_id = '#{User.current.id}') order by projects.name")
  end
  
  def add_project
    @project = FavouriteProject.new
    @project.project_id = params[:id]
    @project.user_id = User.current.id
    if request.post?
      if @project.save then
	flash[:notice] = l('favourite_projects.controllers.add_project_notice')
        redirect_to :controller => 'favourite_projects', :action => 'index'
      end
    end
  end

  def remove_project
    FavouriteProject.destroy(params[:id])
    redirect_to :controller => 'favourite_projects', :action => 'index'
  end

  def save_user_settings
    @user = User.current

    if params[:commit] == l(:button_apply)
      @user.pref[:redmine_favourite_projects] = params[:settings]
      @user.pref[:redmine_favourite_projects] ||= {}
      @user.pref[:redmine_favourite_projects][:user_overriden] = true
      
      if @user.pref.save
        flash[:notice] = l('favourite_projects.controllers.user_settings_override_notice.update')
      end
    elsif params[:commit] == l('favourite_projects.views.index.reset_to_defaults_button')
      @user.pref[:redmine_favourite_projects] = {}

      if @user.pref.save
        flash[:notice] = l('favourite_projects.controllers.user_settings_override_notice.reset')
      end
    else
      flash[:error] = l('favourite_projects.controllers.user_settings_override_notice.error')
    end

    redirect_to :controller => 'favourite_projects', :action => 'index'
  end
  
end
