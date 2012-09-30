class FavouriteProjectsSearchboxHookListener < Redmine::Hook::ViewListener
	render_on :view_layouts_base_html_head, :partial => "favourite_projects/favourite_projects_searchbox_partial"
end