require 'test_helper'

class ArticleIndexResultControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get article_index_result_index_url
    assert_response :success
  end

end
