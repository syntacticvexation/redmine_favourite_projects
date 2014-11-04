require_dependency 'user'

module FavouriteProjectsUserPatch
  def self.included(base)
    base.class_eval do
      unloadable
      has_many :favourite_projects, :class_name => 'FavouriteProject', :dependent => :delete_all

      def ordered_favourite_projects
      	self.favourite_projects.includes(:project).order("projects.name")
      end
    end
  end
end