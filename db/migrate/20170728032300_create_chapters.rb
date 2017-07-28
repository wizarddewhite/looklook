class CreateChapters < ActiveRecord::Migration[5.0]
  def change
    create_table :chapters do |t|
      t.integer :start_second
      t.integer :video_id
      t.timestamps
    end
  end
end
