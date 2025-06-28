# frozen_string_literal: true

require "test_helper"

module Payment
  class CheckPaymentTest < ActiveSupport::TestCase
    test "attributes" do
      cp = CheckPayment.new(routing_number: "route", account_number: "account")

      assert_equal "route", cp.routing_number
      assert_equal "account", cp.account_number
    end

    test "validate routing number" do
      cp = CheckPayment.new

      [ nil, "", "My number", "#1337", "137", "abc" ].each do |value|
        cp.routing_number = value
        cp.validate

        refute_empty cp.errors[:routing_number], "Routing number #{value.inspect} should be rejected"
      end

      %w[1337 ABC-1337 abcd whatever ----].each do |value|
        cp.routing_number = value
        cp.validate

        assert_empty cp.errors[:routing_number], "Routing number #{value.inspect} should be accepted"
      end
    end

    test "validate account number" do
      cp = CheckPayment.new

      [ nil, "", "My number", "#1337", "137", "abc" ].each do |value|
        cp.account_number = value
        cp.validate

        refute_empty cp.errors[:account_number], "Routing number #{value.inspect} should be rejected"
      end

      %w[1337 ABC-1337 abcd whatever ----].each do |value|
        cp.account_number = value
        cp.validate

        assert_empty cp.errors[:account_number], "Routing number #{value.inspect} should be accepted"
      end
    end
  end
end
