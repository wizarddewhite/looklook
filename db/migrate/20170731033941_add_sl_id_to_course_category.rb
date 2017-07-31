class AddSlIdToCourseCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :course_categories, :sl_category_id, :integer
  end
end
