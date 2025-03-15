require "test_helper"

class HeartsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get hearts_create_url
    assert_response :success
  end

  test "should get destroy" do
    get hearts_destroy_url
    assert_response :success
  end
end
