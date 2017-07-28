class ChangeIsEditingToDatetime < ActiveRecord::Migration[5.0]
  def up
    remove_column :videos, :is_editing
    add_column :videos, :is_editing, :datetime
  end
  def down
    remove_column :videos, :is_editing
    add_column :videos, :is_editing, :datetime
  end
end
