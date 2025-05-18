class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :product_id, uniqueness: { scope: :cart_id, message: "already exists in this cart" }

  def total_price
    quantity * product.price
  end
end
