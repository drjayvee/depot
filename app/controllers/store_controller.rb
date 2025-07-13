class StoreController < ApplicationController
  include CurrentCart
  include VisitCount

  before_action :set_cart
  before_action :increment_visit_count

  def index
    @products = Product.order(:title)
  end
end
