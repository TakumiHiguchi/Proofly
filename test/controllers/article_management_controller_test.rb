require 'test_helper'

class ArticleManagementControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get article_management_index_url
    assert_response :success
  end

  test "should get new" do
    get article_management_new_url
    assert_response :success
  end

  test "should get create" do
    get article_management_create_url
    assert_response :success
  end

  test "should get edit" do
    get article_management_edit_url
    assert_response :success
  end

  test "should get update" do
    get article_management_update_url
    assert_response :success
  end

  test "should get destroy" do
    get article_management_destroy_url
    assert_response :success
  end

end
