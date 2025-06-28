# frozen_string_literal: true

module Payment
  class CreditCardPayment < Payment
    attribute :card_number, :string
    attribute :expiration_date, :date

    validates :card_number,
              format: { with: /\A\d{4}-\d{4}-\d{4}-\d{4}\z/ }
    validates :expiration_date, comparison: { greater_than_or_equal_to: Date.today, message: "has expired" }
  end
end
