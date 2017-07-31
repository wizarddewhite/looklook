class AddFlSlCategoryIdToCourse < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :fl_category_id, :integer
    add_column :courses, :sl_category_id, :integer
  end
end
