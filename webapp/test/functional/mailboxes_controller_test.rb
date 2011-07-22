require 'test_helper'

class MailboxesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_redirected_to login_path
  end

  test "should get new" do
    get :new
    assert_redirected_to login_path
  end

  test "should create mailbox" do
    get :create
    assert_redirected_to login_path
  end

  test "should show mailbox" do
    get :show
    assert_redirected_to login_path
  end

  test "should get edit" do
    get :edit
    assert_redirected_to login_path
  end

  test "should update mailbox" do
    post :update
    assert_redirected_to login_path
  end
end
