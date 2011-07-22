require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create client" do
    assert_difference('Client.count') do
      post :create, :client => {"people_attributes"=>{"0"=>{"name"=>"Piyush Ranjan", "email"=>"piyush.pr@gmail.com"}}, "subdomain"=>"piyushpr", "users_attributes"=>{"0"=>{"password1"=>"piyush", "password2"=>"piyush", "username"=>"piyush"}}}
    end
    assert_redirected_to settings_path()
  end
end
