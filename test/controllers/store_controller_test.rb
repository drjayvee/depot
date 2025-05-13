require "test_helper"

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get store_index_url
    assert_response :success
    assert_select "nav a", minimum: 4
    assert_select "main ul li", 2
    assert_select "h2", products(:alaska).title
    assert_select "div", /\$[,\d]+\.\d{2}/
  end
end
