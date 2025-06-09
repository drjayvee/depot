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
    @order = Order.new(order_params)
    @order.line_items = @cart.line_items

    respond_to do |format|
      if @order.save
        @cart.destroy!
        session[:cart_id] = nil
        format.html { redirect_to @order, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
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
      params.expect(order: [ :name, :address, :email, :pay_type ])
    end
end
