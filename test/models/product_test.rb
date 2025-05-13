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

  test "image must be of acceptable type" do
    product = Product.new
    product.image.attach(io: File.open(__FILE__), filename: __FILE__)
    product.validate

    refute_empty product.errors[:image]
    assert_equal "must be a GIF, JPEG or PNG image", product.errors[:image].first

    product.image.attach(io: File.open(Rails.root.join("db", "images", "alaska.jpg")), filename: "alaska.jpg")
    product.validate

    assert_empty product.errors[:image]
  end

  test "cannot delete product in cart" do
    product = products(:alaska) # LineItem exists

    assert_raises(ActiveRecord::RecordNotDestroyed) { product.destroy! }
    refute_empty product.errors[:base]
    assert Product.exists?(product.id)
  end
end
