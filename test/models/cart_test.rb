require "test_helper"

class CartTest < ActiveSupport::TestCase
  test "empty?" do
    cart = carts(:two) # this cart is empty

    assert cart.empty?

    cart.line_items.build(product: products(:alaska), cart:)

    refute cart.empty?
  end

  test "prevent duplicate products" do
    product = products(:alaska)
    cart = carts(:one) # already contains alaska

    cart.line_items.build(product:)

    refute cart.valid?
    refute_empty cart.errors[:line_items]

    # A different cart should be able to add the same product
    new_cart = Cart.new
    new_cart.line_items.build(product: product)

    assert new_cart.valid?
  end
end
