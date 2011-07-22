require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should show login page" do
    get :login
    assert_response :success, :layout => "login"
  end

  test "should successfully login" do
    post :login, :user => {:username => "admin", :password => "piyush1"}
    assert_redirected_to mailboxes_path
    get :logout
    assert_redirected_to login_path
  end

  test "should show wrong username password" do
    post :login, :user => {:username => "admin", :password => "wrong"}
    assert_response :success, :flash => {:error => "Wrong username/password"}
  end

  test "should logout user" do
    post :login, :user => {:username => "admin", :password => "wrong"}
    get :logout
    assert_redirected_to login_path
  end
  
  test "should create client then login user and create mailbox" do
    assert_difference('Client.count') do
      post :create, :client => {"people_attributes"=>{"0"=>{"name"=>"Piyush Ranjan", "email"=>"piyush.pr1234@gmail.com"}}, "subdomain"=>"piyushpr1345", "users_attributes"=>{"0"=>{"password1"=>"piyush", "password2"=>"piyush", "username"=>"piyush"}}}
    end
    assert_redirected_to settings_path(:new)
    get :logout
    assert_redirected_to login_path
    post :login, :user => {:username => "piyush", :password => "piyush"}
    assert_redirected_to settings_path()
    get :new_mailbox_path
    assert :success
    post :mailbox_path, :mailbox => {"server_type"=>"pop", "name"=>"Cleartrip", "username"=>"piyushranjan", "hostname"=>"mail.cleartrip.com", "password"=>"bonney", "email"=>"piyush.ranjan@cleartrip.com"}
    assert_redirected_to client_path
    get :logout    
    assert :success
  end  
end
