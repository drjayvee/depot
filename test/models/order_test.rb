require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "pay_type must be valid" do
    assert_raises(ArgumentError, match: /not a valid pay_type/) do
      Order.new(pay_type: "Wash dishes")
    end
  end

  test "must have at least one line item" do
    order = Order.new

    refute order.valid?
    assert_equal "Order must have at least one line item", order.errors[:line_items].first
  end

  test "total_price" do
    order = Order.new
    product_1 = products(:alaska)
    product_2 = products(:childs_play)

    assert_equal 0, order.total_price

    order.line_items.build(product: product_1)

    assert_equal product_1.price, order.total_price

    order.line_items.first.quantity = 2

    assert_equal 2 * product_1.price, order.total_price

    order.line_items.build(product: product_2, quantity: 3)

    assert_equal 2 * product_1.price + 3 * product_2.price, order.total_price
  end
end
