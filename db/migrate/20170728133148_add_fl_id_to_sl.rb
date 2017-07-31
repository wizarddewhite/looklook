class AddFlIdToSl < ActiveRecord::Migration[5.0]
  def change
    add_column :sl_categories, :fl_category_id, :integer
  end
end
