require 'test_helper'

class NuserControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get nuser_index_url
    assert_response :success
  end

  test "should get show" do
    get nuser_show_url
    assert_response :success
  end

  test "should get create" do
    get nuser_create_url
    assert_response :success
  end

  test "should get destroy" do
    get nuser_destroy_url
    assert_response :success
  end

  test "should get edit" do
    get nuser_edit_url
    assert_response :success
  end

  test "should get new" do
    get nuser_new_url
    assert_response :success
  end

  test "should get update" do
    get nuser_update_url
    assert_response :success
  end

end
