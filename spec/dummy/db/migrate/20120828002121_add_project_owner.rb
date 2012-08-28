class AddProjectOwner < ActiveRecord::Migration
  def up
    add_column :projects, :owner, :string
  end

  def down
    remove_column :projects, :owner
  end
end
