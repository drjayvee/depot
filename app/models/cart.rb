class Cart < ApplicationRecord
  has_many :line_items, dependent: :nullify

  def empty?
    line_items.empty?
  end

  def add_or_increase_quantity(product_id)
    if (line_item_for_product = line_items.where(product_id:).first)
      line_item_for_product.quantity += 1
    else
      line_item_for_product = line_items.build(product_id:)
    end

    line_item_for_product
  end

  def total_price
    line_items.sum(&:total_price)
  end
end
