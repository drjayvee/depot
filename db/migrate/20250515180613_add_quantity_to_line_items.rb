class AddQuantityToLineItems < ActiveRecord::Migration[8.0]
  def up
    add_column :line_items, :quantity, :integer, default: 1

    say "Update #{Cart.count} existing carts"
    Cart.all.each do |cart|
      sums = cart.line_items.group(:product_id).having("sum(quantity) > 1").sum(:quantity)

      sums.each do |product_id, quantity|
        say "Migrating line item(s): product_id=#{product_id}, quantity=#{quantity}"

        cart.line_items.where(product_id: product_id).delete_all
        cart.line_items.create!(product_id: product_id, quantity:)
      end
    end
  end

  def down
    Cart.all.each do |cart|
      cart.line_items.each do |line_item|
        next if line_item.quantity == 1

        cart.line_items.where(product_id: line_item.product_id).delete_all
        line_item.quantity.times do
          cart.line_items.create!(product_id: line_item.product_id)
        end
      end
    end

    remove_column :line_items, :quantity
  end
end
