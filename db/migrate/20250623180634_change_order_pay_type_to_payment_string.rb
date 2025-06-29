class ChangeOrderPayTypeToPaymentString < ActiveRecord::Migration[8.0]
  def up
    remove_column :orders, :pay_type
    add_column :orders, :payment_data, :json, null: false
  end

  def down
    remove_column :orders, :payment_data
    add_column :orders, :pay_type, :integer, null: false
  end
end
