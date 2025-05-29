require "test_helper"

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item_one = line_items(:one)

    @line_item_two = LineItem.create!(
      product: products(:childs_play),
      cart: carts(:one),
      quantity: 3,
    )
  end

  test "should create line_item and cart" do
    assert_difference(%w[LineItem.count Cart.count]) do
      post line_items_url, params: { product_id: products(:alaska).id }
    end

    assert_redirected_to store_index_path

    follow_redirect!
    assert_response :success
  end

  test "should create line_item via turbo-stream" do
    assert_difference(%w[LineItem.count]) do
      post line_items_url, params: { product_id: products(:alaska).id },
           as: :turbo_stream
    end

    assert_response :success
    assert_match /cart--flash/, @response.body
  end

  test "should destroy line_item" do
    assert_difference("LineItem.count", -1) do
      delete line_item_url(@line_item_one)
    end

    assert_redirected_to %r{\A#{cart_url(@line_item_one.cart)}}
  end

  test "should destroy line_item via turbo-stream" do
    assert_difference("LineItem.count", -1) do
      delete line_item_url(@line_item_one),
             as: :turbo_stream
    end

    assert_response :success
    assert_match /<turbo-stream action="remove" target="line_item_#{@line_item_one.id}">/, @response.body
    assert_dom "#cart p", "3 items"
  end

  test "destroy should redirect to store#index when cart is empty" do
    @line_item_two.destroy!

    delete line_item_url(@line_item_one)

    assert_redirected_to store_index_path
  end

  test "destroy using turbo-stream should redirect to store#index when cart is empty" do
    @line_item_two.destroy!

    delete line_item_url(@line_item_one),
           as: :turbo_stream

    assert_redirected_to store_index_path
  end
end
