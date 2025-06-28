# frozen_string_literal: true

require "test_helper"

module Payment
  class PurchaseOrderPaymentTest < ActiveSupport::TestCase
    test "attributes" do
      po = PurchaseOrderPayment.new(number: "#whatever")

      assert_equal "#whatever", po.number
    end

    test "validate number" do
      po = PurchaseOrderPayment.new

      [ nil, "" ].each do |value|
        po.number = value
        po.validate

        refute_empty po.errors[:number], "Empty number should be rejected"
      end

      po.number = "123"
      assert po.validate
    end
  end
end
