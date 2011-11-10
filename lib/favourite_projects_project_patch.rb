require_dependency 'project'

module FavouriteProjectsProjectPatch
  def self.included(base)
    base.class_eval do
      unloadable
      has_many :favourite_projects, :class_name => 'FavouriteProject', :dependent => :delete_all
    end
  end
end