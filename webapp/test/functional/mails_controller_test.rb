require 'test_helper'

class MailsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_redirected_to login_path
  end

  test "should get new" do
    get :new
    assert_redirected_to login_path
  end

  test "should create mail" do
    post :create
    assert_redirected_to login_path
  end

  test "should show mail" do
    get :show
    assert_redirected_to login_path
  end
end
