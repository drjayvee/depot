require "test_helper"

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:one)
  end

  test "should create line_item and cart" do
    assert_difference(%w[LineItem.count Cart.count]) do
      post line_items_url, params: { product_id: products(:alaska).id }
    end

    assert_redirected_to %r{\A#{cart_url(Cart.last)}}

    follow_redirect!
    assert_response :success
  end

  test "should destroy line_item" do
    assert_difference("LineItem.count", -1) do
      delete line_item_url(@line_item)
    end

    assert_redirected_to %r{\A#{cart_url(@line_item.cart)}}

    follow_redirect!
    assert_response :success
  end
end
