# Create data-test-id attributes for use in test.
# Only works in test and development environments (no-op in production)
module DomTestIdHelper
  def dom_test_id(id)
    return "" unless Rails.env.test? || Rails.env.development?

    %(data-test-id="#{id}").html_safe
  end
end
