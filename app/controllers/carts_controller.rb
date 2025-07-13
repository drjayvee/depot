class CartsController < ApplicationController
  before_action :set_cart, only: %i[ show destroy ]

  # GET /carts/1 or /carts/1.json
  def show
  end

  # DELETE /carts/1 or /carts/1.json
  def destroy
    @cart.destroy!
    session.delete :cart_id

    redirect_to store_index_path, status: :see_other, notice: "Cart was successfully emptied."
  end

  private

    def set_cart
      cart_id_param = params.expect(:id).to_i
      session_cart_id = session[:cart_id]
      invalid_cart unless cart_id_param == session_cart_id
      @cart = Cart.find(session_cart_id)
    rescue ActiveRecord::RecordNotFound
      invalid_cart
    end

    def invalid_cart
      logger.error "Attempt to access invalid cart: #{params[:id]}"
      redirect_to store_index_path, notice: "Invalid cart"
    end
end
