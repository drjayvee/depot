class StoreController < ApplicationController
  include VisitCount

  before_action :increment_visit_count
  def index
    @products = Product.order(:title)
  end
end
