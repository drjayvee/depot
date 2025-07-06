class OrdersController < ApplicationController
  include CurrentCart

  before_action :set_cart, only: %i[ new create ]
  before_action :ensure_cart_is_not_empty, only: %i[ new ]
  before_action :set_order, only: %i[ show ]

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params.except(:payment))
    @order.payment = Payment::Payment.load(order_params[:payment].to_h)
    @order.transfer_line_items_from_cart @cart

    if @order.save
      @cart.destroy!
      OrderMailer.with(order: @order).received.deliver_later

      session[:cart_id] = nil
      redirect_to @order, notice: "Order was successfully created."
    else
      # TODO: Bug! Line items have been removed from cart!
      render :new, status: :unprocessable_entity
    end
  end

  private
    def set_order
      @order = Order.find(params.expect(:id))
    end

    def ensure_cart_is_not_empty
      redirect_to store_index_path, notice: "You cart is empty" if @cart.empty?
    end

    def order_params
      params.expect(order: [
        :name,
        :address,
        :email,
        payment: [
          :type,
          :routing_number, :account_number,      # CheckPayment
          :credit_card_number, :expiration_date, # CreditCardPayment
          :number,                               # PurchaseOrderPayment
        ],
      ])
    end
end
