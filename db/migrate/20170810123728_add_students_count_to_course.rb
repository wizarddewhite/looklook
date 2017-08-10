class AddStudentsCountToCourse < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :students_count, :integer, default: 0
  end
end
