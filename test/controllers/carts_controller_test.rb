require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # We have let LineItemsController create a cart and store its id in the session
    post line_items_path, params: { product_id: products(:alaska).id }
    @cart = Cart.find(session[:cart_id])
  end

  test "should show cart" do
    get cart_url(@cart)
    assert_response :success
  end

  test "should destroy cart" do
    assert_difference("Cart.count", -1) do
      delete cart_url(@cart)
    end

    assert_redirected_to carts_url
  end
end
