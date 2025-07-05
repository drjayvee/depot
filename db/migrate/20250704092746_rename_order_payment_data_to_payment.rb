class RenameOrderPaymentDataToPayment < ActiveRecord::Migration[8.0]
  def change
    rename_column :orders, :payment_data, :payment
  end
end
