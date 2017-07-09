class AddCategoryToCourse < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :course_category_id, :integer
  end
end
