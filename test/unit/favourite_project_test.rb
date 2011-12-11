require File.dirname(__FILE__) + '/../test_helper'

class FavouriteProjectTest < ActiveSupport::TestCase
  fixtures :favourite_projects,:projects

  def setup
    @ecookbook = Project.find(1)
    @ecookbook_sub = Project.find(3)
    @adminuser = User.find(1)
    @firstfav = FavouriteProject.new
    @firstfav.project = @ecookbook
    @firstfav.user = @adminuser
    assert @firstfav.save
    
    @secondfav = FavouriteProject.new
    @secondfav.project = @ecookbook_sub
    @secondfav.user = @adminuser
    assert @secondfav.save
  end
  
  def test_001_kind_of
    assert_kind_of FavouriteProject, @firstfav
    assert_kind_of Project, @firstfav.project
    assert_kind_of User, @firstfav.user
  end
  
#   def test_default_attributes
#     with_settings :modifyProjectJumpList => false do
#       
#     end
#     
#     with_settings :modifyTopMenu => false do
#     
#     end
#   end
  
  def test_002_destroying_subproject_should_delete_favourite
    assert_equal 2, FavouriteProject.count, "#{FavouriteProject.count} favourites exist"
    @ecookbook_sub.destroy
    assert_equal 1, FavouriteProject.count, "#{FavouriteProject.count}  favourites exist"
    
    # make sure that the subproject no longer exists
    assert_raise(ActiveRecord::RecordNotFound) { Project.find(@ecookbook_sub.id) }
    
    # make sure that favourite no longer exists after destroying project
    assert_raise(ActiveRecord::RecordNotFound) { FavouriteProject.find(@secondfav.id) } 
  end
  
  def test_003_destroying_project_should_delete_favourite
    assert_equal 2, FavouriteProject.count, "#{FavouriteProject.count} favourites exist"
    @ecookbook.destroy
    assert_equal 0, FavouriteProject.count, "#{FavouriteProject.count}  favourites exist"
    
    # make sure that the project no longer exists
    assert_raise(ActiveRecord::RecordNotFound) { Project.find(@ecookbook.id) }
    
    # make sure that favourite no longer exists after destroying project
    assert_raise(ActiveRecord::RecordNotFound) { FavouriteProject.find(@firstfav.id) } 
  end
  
  def test_004_delete_user_should_delete
    assert_equal 2, FavouriteProject.count, "#{FavouriteProject.count} favourites exist"
    @adminuser.destroy
    assert_equal 0, FavouriteProject.count, "#{FavouriteProject.count}  favourites exist"
    
    # make sure that the user no longer exists
    assert_raise(ActiveRecord::RecordNotFound) { User.find(@adminuser.id) }
    
    # make sure that favourite no longer exists after destroying project
    assert_raise(ActiveRecord::RecordNotFound) { FavouriteProject.find(@firstfav.id) } 
  end
  
end
