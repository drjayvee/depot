# frozen_string_literal: true

module Payment
  class PurchaseOrderPayment < Payment
    attribute :number, :string

    validates_presence_of :number
  end
end
