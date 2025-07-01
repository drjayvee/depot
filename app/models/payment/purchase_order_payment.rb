# frozen_string_literal: true

module Payment
  class PurchaseOrderPayment < Payment
    attribute :number, :string

    validates :number, presence: true
  end
end
