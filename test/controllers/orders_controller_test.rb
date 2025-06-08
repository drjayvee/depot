require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
  end

  test "should get index" do
    get orders_url
    assert_response :success
  end

  test "should get new" do
    get new_order_url # session[:cart_id] doesn't yet exist

    assert_redirected_to store_index_path

    cart = Cart.find(session[:cart_id])
    cart.line_items.create!(product_id: products(:alaska).id)

    get new_order_url, params: { cart_id: cart.id }
    assert_response :success
  end

  test "should create order" do
    get new_order_url # session[:cart_id] doesn't yet exist

    cart = Cart.find(session[:cart_id])
    cart.line_items.create!(product_id: products(:alaska).id)

    assert_difference("Order.count") do
      post orders_url, params: { order: { address: @order.address, email: @order.email, name: @order.name, pay_type: @order.pay_type }, cart_id: cart.id }
    end

    assert_redirected_to order_url(Order.last)
  end

  test "should show order" do
    get order_url(@order)
    assert_response :success
  end

  test "should get edit" do
    get edit_order_url(@order)
    assert_response :success
  end

  test "should update order" do
    LineItem.create!(product: products(:alaska), order_id: @order.id)

    patch order_url(@order), params: { order: { address: @order.address, email: @order.email, name: @order.name, pay_type: @order.pay_type } }
    assert_redirected_to order_url(@order)
  end

  test "should destroy order" do
    assert_difference("Order.count", -1) do
      delete order_url(@order)
    end

    assert_redirected_to orders_url
  end
end
