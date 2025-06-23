class MakeOrderFieldsNotNullable < ActiveRecord::Migration[8.0]
  def up
    change_column :orders, :name, :string, null: false
    change_column :orders, :address, :text, null: false
    change_column :orders, :email, :string, null: false
    change_column :orders, :pay_type, :integer, null: false
  end

  def down
    change_column :orders, :name, :string, null: true
    change_column :orders, :address, :text, null: true
    change_column :orders, :email, :string, null: true
    change_column :orders, :pay_type, :integer, null: true
  end
end
