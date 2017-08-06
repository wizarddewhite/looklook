class AddExpireToCoupon < ActiveRecord::Migration[5.0]
  def change
    add_column :coupons, :expire, :date
  end
end
