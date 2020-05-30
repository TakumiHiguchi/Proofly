require 'test_helper'

class WorkManagementControllerTest < ActionDispatch::IntegrationTest
  test "should get article" do
    get work_management_article_url
    assert_response :success
  end

end
