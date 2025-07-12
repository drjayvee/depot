require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "name is required" do
    user = User.new
    user.validate

    refute_empty user.errors[:name]

    user.name = "Jay"
    user.validate

    assert_empty user.errors[:name]
  end

  test "email must be present and valid" do
    user = User.new
    user.validate

    assert_match "blank", user.errors[:email_address].first

    user.email_address = "jay"
    user.validate

    assert_match "invalid", user.errors[:email_address].first

    user.email_address = "jay@hey.com"
    user.validate

    assert_empty user.errors[:email_address]
  end

  test "email must be unique" do
    user = User.new(email_address: users(:one).email_address)
    user.validate

    refute_empty user.errors[:email_address]
    assert_match "has already been taken", user.errors[:email_address].first
  end
end
