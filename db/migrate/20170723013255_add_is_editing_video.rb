class AddIsEditingVideo < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :is_editing, :boolean, default: false
  end
end
