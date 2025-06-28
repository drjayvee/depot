# frozen_string_literal: true

require "test_helper"

module Payment
  class CreditCardPaymentTest < ActiveSupport::TestCase
    test "attributes" do
      ccp = CreditCardPayment.new(card_number: "1337-1337-1337-1337", expiration_date: Date.today)

      assert_equal "1337-1337-1337-1337", ccp.card_number
      assert_equal Date.today, ccp.expiration_date
    end

    test "validate card number" do
      ccp = CreditCardPayment.new

      [ nil, "", "1337-1337-1337-ABCD", "1337-1337-1337-133", "11337-1337-1337-13337" ].each do |value|
        ccp.card_number = value
        ccp.validate

        refute_empty ccp.errors[:card_number], "Card number #{value.inspect} should be rejected"
      end

      %w[1337-1337-1337-1337 0000-0000-0000-0000].each do |value|
        ccp.card_number = value
        ccp.validate

        assert_empty ccp.errors[:card_number], "Card number #{value.inspect} should be accepted"
      end
    end

    test "validate expiration date" do
      ccp = CreditCardPayment.new

      [ nil, Date.yesterday, 1.year.ago ].each do |value|
        ccp.expiration_date = value
        ccp.validate

        refute_empty ccp.errors[:expiration_date], "Expiration date #{value.inspect} should be rejected"
        assert_match "has expired", ccp.errors[:expiration_date].join
      end

      [ Date.today, Date.tomorrow, 1.year.from_now ].each do |value|
        ccp.expiration_date = value
        ccp.validate

        assert_empty ccp.errors[:expiration_date], "Expiration date #{value.inspect} should be accepted"
      end
    end
  end
end
