module FavouriteProjectsMenuPatch

  def self.included(base)
    base.send(:extend, ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :render_menu, :favourite_projects
    end
  end

  module ClassMethods
  end

  module InstanceMethods
    def render_menu_with_favourite_projects(menu, project=nil)
      if (menu == :top_menu and calculated_favourite_projects_settings['modifyTopMenu'])
          links = []
          menu_items_for(menu, project) do |node|
            links << render_menu_node(node, project)
          end

          User.current.ordered_favourite_projects.each do |fav|
            links << link_to(fav.project.name, fav.project, :class => 'icon icon-projects')
          end

          #links.empty? ? nil : content_tag('ul', links.join.html_safe)
          unless links.empty?
                content_tag(:ul, :class => '') do
                        links.collect do |x|
                                content_tag(:li, x)
                        end.join.html_safe
                end
          end

        
      else
        render_menu_without_favourite_projects(menu, project)
      end
    end
  end
end
