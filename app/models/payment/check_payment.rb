# frozen_string_literal: true

module Payment
  class CheckPayment < Payment
    attribute :routing_number, :string
    attribute :account_number, :string

    validates :routing_number, :account_number,
              format: { with: /\A[\w-]{4,}\z/ }
  end
end
