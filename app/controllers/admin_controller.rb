class AdminController < ApplicationController
  include Authentication

  def index
    @user = Current.user
    @orders_count = Order.count
  end
end
