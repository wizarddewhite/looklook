class AddHashidToCourse < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :hashid, :string
  end
end
