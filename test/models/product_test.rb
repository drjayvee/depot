require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "price must be > 0.00" do
    product = Product.new(price: 0.00)
    product.validate

    assert_not_empty product.errors[:price]

    product.price = 0.01
    product.validate

    assert_empty product.errors[:price]
  end
end
