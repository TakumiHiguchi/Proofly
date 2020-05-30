require 'test_helper'

class ArticleApiControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get article_api_index_url
    assert_response :success
  end

end
