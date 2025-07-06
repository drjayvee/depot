# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview
  def received
    OrderMailer.with(order: Order.first).received
  end

  def shipped
    OrderMailer.with(order: Order.first).shipped
  end
end
