class AddCourseidToVideo < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :course_id, :integer
  end
end
