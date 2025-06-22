class Order < ApplicationRecord
  enum :pay_type, {
    check: 0,
    credit_card: 1,
    purchase_order: 2
  }, validate: true

  PAY_TYPE_NAMES = {
    check: "Check",
    credit_card: "Credit card",
    purchase_order: "Purchase order"
  }

  validates_presence_of :name, :address, :email, :pay_type

  has_many :line_items, dependent: :destroy
  validates :line_items, length: { minimum: 1, message: "Order must have at least one line item" }

  def total_price
    line_items.sum(&:total_price)
  end

  def transfer_line_items_from_cart(cart)
    cart.line_items.each do |item|
      line_items << item
      cart.line_items.delete item
    end
  end
end
