# frozen_string_literal: true

require "ostruct"

class Pago
  def self.make_payment(order)
    payment = order.payment
    case payment
    when Payment::CheckPayment
      Rails.logger.info "Processing check: %s / %s" % [
        payment.routing_number,
        payment.account_number,
      ]
    when Payment::CreditCardPayment
      Rails.logger.info "Processing credit card: %s (%s)" % [
        payment.card_number,
        payment.expiration_date,
      ]
    when Payment::PurchaseOrderPayment
      Rails.logger.info "Processing purchase order: %s" % [
        payment.number,
      ]
    else
      raise NotImplementedError.new "Unsupported payment"
    end

    sleep 3 unless Rails.env.test?
    Rails.logger.info "Done processing payment #{payment.object_id}"
    OpenStruct.new(succeeded?: true)
  end
end
