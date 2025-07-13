class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart, optional: true
  belongs_to :order, optional: true

  validate :ensure_belongs_to_cart_or_order

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :product_id, uniqueness: { scope: :cart_id, message: "already exists in this cart" }

  def total_price
    quantity * product.price
  end

  private

    def ensure_belongs_to_cart_or_order
      if cart.nil? && order.nil?
        errors.add :base, "Must belong to cart or order"
        throw :abort
      end
    end
end
