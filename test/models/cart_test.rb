require "test_helper"

class CartTest < ActiveSupport::TestCase
  test "empty?" do
    cart = carts(:two) # this cart is empty

    assert cart.empty?

    cart.line_items.build(product: products(:alaska), cart:)

    refute cart.empty?
  end
end
