require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "requires authentication" do
    get admin_index_url
    assert_redirected_to new_session_path
  end

  test "should get index" do
    login_as users(:one)
    get admin_index_url
    assert_response :success
  end
end
