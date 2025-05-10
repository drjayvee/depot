require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "title must be present and not empty" do
    product = Product.new
    product.validate

    refute_empty product.errors[:title]

    product.title = ""
    product.validate

    refute_empty product.errors[:title]

    product.title = "My best stuff"
    product.validate

    assert_empty product.errors[:title]
  end

  test "title must be unique" do
    Product.create!(title: "Stuff", description: "My very best stuff", price: 1337)

    product = Product.new(title: "Stuff")
    product.validate

    refute_empty product.errors[:title]
    assert_equal "has already been taken", product.errors[:title].first
  end

  test "description must be present and not empty" do
    product = Product.new
    product.validate

    refute_empty product.errors[:description]

    product.description = ""
    product.validate

    refute_empty product.errors[:description]

    product.description = "My very best stuff"
    product.validate

    assert_empty product.errors[:description]
  end

  test "price must be present" do
    product = Product.new
    product.validate

    refute_empty product.errors[:price]

    product.price = 1337
    product.validate

    assert_empty product.errors[:price]
  end

  test "price must be > 0.00" do
    product = Product.new(price: 0.00)
    product.validate

    refute_empty product.errors[:price]

    product.price = 0.01
    product.validate

    assert_empty product.errors[:price]
  end
end
