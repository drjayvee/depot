class Order < ApplicationRecord
  validates :name, :address, :email, :payment, presence: true

  has_many :line_items, dependent: :destroy
  validates :line_items, length: { minimum: 1, message: "Order must have at least one line item" }

  validate :validate_payment
  serialize :payment, coder: Payment::Payment

  def total_price
    line_items.sum(&:total_price)
  end

  def transfer_line_items_from_cart(cart)
    cart.line_items.each do |item|
      line_items << item
      cart.line_items.delete item
    end
  end

  def charge!
    Pago.make_payment(self)
  end

  private

  def validate_payment
    return if payment.nil?

    unless payment.validate
      errors.add(:payment, payment.errors.full_messages.join)
    end
  end
end
