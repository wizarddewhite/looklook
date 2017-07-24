class CreateCoupons < ActiveRecord::Migration[5.0]
  def change
    create_table :coupons do |t|
      t.integer :price
      t.integer :quantity
      t.integer :course_id
      t.string :token

      t.timestamps
    end
  end
end
