require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "attrs must be present" do
    %i[name address email pay_type].each do |attr|
      order = Order.new
      order.validate

      assert_not_empty order.errors[attr], "Expected an error for missing attribute #{attr}"

      order[attr] = "Check"
      order.validate

      assert_empty order.errors[attr], "Expected no error for attribute #{attr} with value 'Check'"
    end
  end

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

  test "transfer line items from cart" do
    cart = Cart.new
    line_item = cart.line_items.build(product: products(:alaska))

    order = orders(:one)
    order.transfer_line_items_from_cart cart

    assert cart.empty?
    assert_same 1, order.line_items.size
    assert_equal line_item.id, order.line_items.first.id
    assert_nil order.line_items.first.cart
  end

  test "destroying an order should delete its line items" do
    line_item = line_items(:one)

    order = orders(:one)
    order.line_items << line_item
    order.save!
    order.destroy!

    assert_raises ActiveRecord::RecordNotFound do
      LineItem.find(line_item.id)
    end
  end
end
