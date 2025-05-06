class SpecifyProductPricePrecision < ActiveRecord::Migration[8.0]
  def change
    change_column :products, :price, :decimal, precision: 8, scale: 2
  end
end
