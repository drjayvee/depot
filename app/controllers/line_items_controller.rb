class LineItemsController < ApplicationController
  include CurrentCart
  include VisitCount

  before_action :set_cart, only: %i[ create ]
  before_action :reset_visit_count, only: :create

  # POST /line_items or /line_items.json
  def create
    @line_item = @cart.add_or_increase_quantity(params[:product_id])

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_index_path, status: :see_other, notice: "Product was added to your cart." }
        format.turbo_stream
      else
        @cart.reload
        format.html { render @line_item.cart, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1 or /line_items/1.json
  def destroy
    @line_item = LineItem.find(params.expect(:id))
    @cart = @line_item.cart

    @line_item.destroy!

    respond_to do |format|
      format.html { redirect_after_destroy }
      format.turbo_stream unless @cart.empty? # If cart is empty, redirect to store
    end
  end

  private

    def redirect_after_destroy
      redirect_to(
        @cart.empty? ? store_index_path : cart_path(@line_item.cart),
        status: :see_other,
        notice: "Product was removed from your cart"
      )
    end
end
