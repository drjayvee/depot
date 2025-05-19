class LineItemsController < ApplicationController
  include CurrentCart
  include VisitCount

  before_action :set_cart
  before_action :set_line_item, only: %i[ destroy ]
  before_action :reset_visit_count, only: :create

  # POST /line_items or /line_items.json
  def create
    @line_item = @cart.add_or_increase_quantity(params[:product_id])

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_index_path, notice: "Line item was successfully created." }
        format.json { render :show, status: :created, location: @line_item }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            :cart,
            partial: 'layouts/cart',
            locals: { cart: @cart }
          )
        end
      else
        @cart.reload
        format.html { render @line_item.cart, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1 or /line_items/1.json
  def destroy
    @line_item.destroy!

    respond_to do |format|
      format.html { redirect_to cart_path @line_item.cart, status: :see_other, notice: "Line item was successfully destroyed." }
      format.json { head :no_content }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          :cart,
          partial: 'layouts/cart',
          locals: { cart: @cart }
        )
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params.expect(:id))
    end
end
