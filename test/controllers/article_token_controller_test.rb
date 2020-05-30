require 'test_helper'

class ArticleTokenControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get article_token_index_url
    assert_response :success
  end

  test "should get new" do
    get article_token_new_url
    assert_response :success
  end

  test "should get create" do
    get article_token_create_url
    assert_response :success
  end

  test "should get edit" do
    get article_token_edit_url
    assert_response :success
  end

  test "should get update" do
    get article_token_update_url
    assert_response :success
  end

end
