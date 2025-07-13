class OrderMailer < ApplicationMailer
  before_action :set_order

  def received
    mail to: @order.email, subject: "Your Depot order"
  end

  def shipped
    mail to: @order.email, subject: "Your Depot order just shibbed"
  end

  private

    def set_order
      @order = params[:order]
    end
end
