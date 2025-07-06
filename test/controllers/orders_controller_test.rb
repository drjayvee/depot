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

  test "should create order and destroy cart" do
    get new_order_url # session[:cart_id] doesn't yet exist

    cart = Cart.find(session[:cart_id])
    cart.line_items.create!(product_id: products(:alaska).id)

    assert_difference(
      -> { Order.count } => 1,
      -> { Cart.count }  => -1
    ) do
      post(orders_url, params: { order: {
        address: @order.address,
        email: @order.email,
        name: @order.name,
        payment: {
          type: @order.payment.as_json["type"],
          routing_number: "", # simulate full form
          number: @order.payment.number
        },
        cart_id: cart.id
      } })
    end

    email_order = nil
    assert_enqueued_email_with OrderMailer, :received,
      params: ->(params) { email_order = params[:order] }

    assert_equal @order.name, email_order.name
    assert_equal @order.email, email_order.email
    assert_equal 1, email_order.line_items.count # @order.line_items is now empty!
    assert_equal @order.payment.to_json, email_order.payment.to_json

    assert_redirected_to order_url(Order.last)
  end

  test "should show order" do
    get order_url(@order)
    assert_response :success
  end
end
