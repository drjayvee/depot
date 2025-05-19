require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper

  setup do
    @alaska = products(:alaska)
    @childs_play = products(:childs_play)

    # We have let LineItemsController create a cart and store its id in the session
    post line_items_path, params: { product_id: @childs_play.id }
    @cart = Cart.find(session[:cart_id])
    @cart.line_items.create!({ product: @alaska, quantity: 2 })
  end

  test "should show cart" do
    get cart_url(@cart)
    assert_response :success

    @cart.line_items.each_with_index do |line_item, i|
      assert_dom "tr:nth-child(#{i + 2})" do
        assert_dom "td:nth-child(1)", line_item.quantity.to_s
        assert_dom "td:nth-child(2)", line_item.product.title
        assert_dom "td:nth-child(3)", number_to_currency(line_item.product.price)
        assert_dom "td:nth-child(4)", number_to_currency(line_item.total_price)
      end
    end

    assert_dom "[data-test-id=\"cart_total\"]", "Total: #{number_to_currency @cart.total_price}"
  end

  test "should destroy cart" do
    assert_difference("Cart.count", -1) do
      delete cart_url(@cart)
    end

    assert_redirected_to carts_url
  end
end
