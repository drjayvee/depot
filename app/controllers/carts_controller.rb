class CartsController < ApplicationController
  before_action :set_cart, only: %i[ show update destroy ]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  # GET /carts/1 or /carts/1.json
  def show
  end

  # POST /carts or /carts.json
  def create
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: "Cart was successfully created." }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { redirect_to store_index_path, status: :unprocessable_entity }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1 or /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: "Cart was successfully updated." }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { redirect_to @cart, status: :unprocessable_entity }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1 or /carts/1.json
  def destroy
    @cart.destroy!

    respond_to do |format|
      format.html { redirect_to carts_path, status: :see_other, notice: "Cart was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def cart_params
      params.fetch(:cart, {})
    end

    def invalid_cart
      logger.error "Attempt to access invalid cart: #{params[:id]}"
      redirect_to store_index_path, notice: "Invalid cart"
    end
end
