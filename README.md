# Depot

This is my implementation of the Depot application from [Sam Ruby's Agile Web Development with Rails 8](https://pragprog.com/titles/rails8/agile-web-development-with-rails-8/).

I've made a number of changes and/or extensions:
 * Add a [product/:id/hovercard](https://github.com/drjayvee/depot/blob/main/app/controllers/products_controller.rb#L17) route
 * `Order` serializes [Payment](https://github.com/drjayvee/depot/blob/main/app/models/payment/payment.rb) instead of using a separate Model
