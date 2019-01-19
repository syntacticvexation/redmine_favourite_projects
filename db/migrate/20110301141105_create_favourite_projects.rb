class CreateFavouriteProjects < ActiveRecord::Migration[4.2]
  def self.up
    create_table :favourite_projects do |t|
      t.column :user_id, :integer, :null => false
      t.column :project_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :favourite_projects
  end
end
