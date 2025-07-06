require "test_helper"

class OrderMailerTest < ActionMailer::TestCase
  setup do
    @order = orders(:one)
    @order.line_items.create(product: products(:alaska), quantity: 1)
    @order.line_items.create(product: products(:childs_play), quantity: 3)
  end

  test "received" do
    mail = OrderMailer.with(order: @order).received
    assert_equal "Your Depot order", mail.subject
    assert_equal [ @order.email ], mail.to

    text_content = mail.text_part.body.to_s
    html_content = mail.html_part.body.to_s

    assert_match "Dear #{@order.name}", text_content
    assert_match "Dear #{@order.name}", html_content

    assert_line_items(@order, html_content, text_content)
  end

  test "shipped" do
    mail = OrderMailer.with(order: @order).shipped

    assert_equal "Your Depot order just shibbed", mail.subject
    assert_equal [ @order.email ], mail.to

    text_content = mail.text_part.body.to_s
    html_content = mail.html_part.body.to_s

    assert_match "Dear #{@order.name}", text_content
    assert_match "Dear #{@order.name}", html_content

    assert_line_items(@order, html_content, text_content)

    assert_match "Enjoy", text_content
    assert_match "Enjoy", html_content
  end

  private

  def assert_line_items(order, html_content, text_content)
    order.line_items.each do |line_item|
      assert_match "#{line_item.quantity}x #{line_item.product.title}", text_content

      assert_match "#{line_item.quantity}&times;", html_content
      assert_match ERB::Util.html_escape(line_item.product.title), html_content
    end
  end
end
