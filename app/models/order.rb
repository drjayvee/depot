class Order < ApplicationRecord
  validates_presence_of :name, :address, :email, :payment_data

  has_many :line_items, dependent: :destroy
  validates :line_items, length: { minimum: 1, message: "Order must have at least one line item" }

  validate :validate_payment

  def total_price
    line_items.sum(&:total_price)
  end

  def transfer_line_items_from_cart(cart)
    cart.line_items.each do |item|
      line_items << item
      cart.line_items.delete item
    end
  end

  def payment_data=(data)
    @payment = nil
    super
  end

  def payment
    return nil if payment_data.nil?

    @payment ||= Payment::Payment.from_json(payment_data)
  end

  def payment=(payment)
    throw ArgumentError unless payment.kind_of? Payment::Payment

    @payment = payment
    self.payment_data = payment.as_json
  end

  private

  def validate_payment
    return if payment.nil?

    unless payment.validate
      errors.add(:payment_data, payment.errors.full_messages.join)
    end
  end
end
