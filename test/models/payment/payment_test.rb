# frozen_string_literal: true

require "test_helper"

module Payment
  class PaymentTest < ActiveSupport::TestCase
    test "cannot create Payment instance" do
      assert_raises(NotImplementedError) { Payment.new }
    end

    test "can set attributes in new" do
      cp = CheckPayment.new(account_number: "account")

      assert_equal "account", cp.account_number
    end

    test "as_json includes :type key with class name" do
      TYPE_CLASSES.each_pair do |pair|
        pair => [ type, klass ]
        json = klass.new.as_json

        assert_includes json.keys, "type"
        assert_equal type, json["type"]
      end
    end

    test "can serialize to and from JSON" do
      cp1 = CheckPayment.new(account_number: "ACC-1337")

      %i[to_json as_json].each do |method|
        cp2 = CheckPayment.from_json(cp1.send(method))

        assert_kind_of CheckPayment, cp2
        assert_equal cp1.account_number, cp2.account_number
        assert_nil cp2.routing_number
      end
    end

    test "Payment.from_json ignores keys" do
      cp1 = CheckPayment.new(account_number: "ACC-1337")

      CheckPayment.from_json(cp1.as_json.merge(ignore: :me))
      pass
    rescue ActiveModel::UnknownAttributeError
      flunk "UnknownAttributeError was raised"
    end
  end
end
