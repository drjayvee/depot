class Order < ApplicationRecord
  enum :pay_type, {
    "Check"          => 0,
    "Credit card"    => 1,
    "Purchase order" => 2
  }

  validates_presence_of :name, :address, :email, :pay_type

  has_many :line_items
  validates :line_items, length: { minimum: 1, message: "Order must have at least one line item" }

  def total_price
    line_items.sum(&:total_price)
  end
end
