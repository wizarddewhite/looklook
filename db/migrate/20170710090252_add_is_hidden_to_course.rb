class AddIsHiddenToCourse < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :is_hidden, :boolean, default: true
  end
end
