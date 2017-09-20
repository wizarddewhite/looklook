class AddPositionToVideo < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :position, :integer
  end
end
