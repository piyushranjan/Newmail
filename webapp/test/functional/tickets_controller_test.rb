require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
  test "should get redirected when hits assign" do
    get :assign
    assert_redirected_to login_path
  end
  test "should get redirected when hits close" do
    get :close
    assert_redirected_to login_path
  end

end
