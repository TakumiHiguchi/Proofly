require 'test_helper'

class SerachControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get serach_show_url
    assert_response :success
  end

end
