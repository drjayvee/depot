require "test_helper"

class LineItemTest < ActiveSupport::TestCase
  def setup
    @cart = carts(:two)
    @product = products(:alaska)
  end

  test "quantity defaults to 1" do
    line_item = LineItem.new(product: @product)

    assert_equal 1, line_item.quantity
  end

  test "quantity must be positive" do
    line_item = LineItem.new(product: @product, cart: @cart, quantity: 0)
    refute line_item.valid?
    refute_empty line_item.errors[:quantity]

    line_item.quantity = 1
    assert line_item.valid?
  end

  test "total_price" do
    line_item = LineItem.new(product: @product, cart: @cart, quantity: 1)
    assert_equal @product.price, line_item.total_price

    line_item.quantity = 2
    assert_equal 2 * @product.price, line_item.total_price
  end
end
