require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
  end

  test "should not get index if unauthenticated" do
    get orders_url
    assert_response :found
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
      -> { Cart.count } => -1
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

    # Created a new order
    created_order = Order.last
    refute_equal @order.id, created_order.id
    assert_equal @order.name, created_order.name
    assert_equal @order.email, created_order.email
    assert_equal 1, created_order.line_items.count # @order.line_items is now empty!
    assert_equal @order.payment.to_json, created_order.payment.to_json

    # ChargeOrderJob and OrderMailer
    assert_enqueued_with job: ChargeOrderJob, args: [ created_order ]
    assert_enqueued_email_with OrderMailer, :received, params: { order: created_order }

    assert_redirected_to store_index_path
  end

  test "should not show order if unauthenticated" do
    get order_url(@order)
    assert_response :found
  end
end
