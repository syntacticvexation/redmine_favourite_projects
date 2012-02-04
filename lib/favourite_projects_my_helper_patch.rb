require_dependency 'my_helper'

module FavouriteProjectsMyHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
  end
  
  module InstanceMethods
    # function used with permission from RedmineCRM's Favorite projects plugin
    # (http://redminecrm.com/projects/favoriteprojects
    def favourite_project_modules_links(project)
      links = []
      menu_items_for(:project_menu, project) do |node|
	links << link_to(extract_node_details(node, project)[0], extract_node_details(node, project)[1]) unless node.name == :overview
      end
      links.join(", ")
    end
  end
end
