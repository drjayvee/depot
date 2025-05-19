require "test_helper"

class CartTest < ActiveSupport::TestCase
  def setup
    @alaska = products(:alaska)
    @childs_play = products(:childs_play)
  end

  test "empty?" do
    cart = carts(:two) # this cart is empty

    assert cart.empty?

    cart.line_items.build(product: @alaska)

    refute cart.empty?
  end

  test "add_or_increase_quantity" do
    cart = Cart.new

    line_item = cart.add_or_increase_quantity(@alaska.id)
    assert_equal @alaska, line_item.product
    assert_equal 1, line_item.quantity

    line_item.save

    line_item = cart.add_or_increase_quantity(@alaska.id)
    assert_equal @alaska, line_item.product
    assert_equal 2, line_item.quantity

    line_item.save

    line_item = cart.add_or_increase_quantity(@childs_play.id)
    assert_equal @childs_play, line_item.product
    assert_equal 1, line_item.quantity
  end

  test "total_price" do
    cart = Cart.new
    cart.line_items.build(product: @alaska, quantity: 2)

    assert_equal 2 * @alaska.price, cart.total_price
  end

  test "prevent duplicate products" do
    cart = carts(:one) # already contains alaska

    cart.line_items.build(product: @alaska)

    refute cart.valid?
    refute_empty cart.errors[:line_items]

    # A different cart should be able to add the same product
    new_cart = Cart.new
    new_cart.line_items.build(product: @alaska)

    assert new_cart.valid?
  end
end
