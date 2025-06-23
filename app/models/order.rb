class Order < ApplicationRecord
  validates_presence_of :name, :address, :email
  validates_inclusion_of :pay_type, in: Payment::TYPES.values, allow_nil: false

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
