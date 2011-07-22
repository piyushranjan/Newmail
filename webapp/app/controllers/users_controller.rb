class UsersController < ApplicationController
  layout "login"
  skip_before_filter :login_required, :only => [:login]

  def login
    if @current_user
      redirect_to mailboxes_path
      return
    elsif params[:user] and params[:user][:username] and params[:user][:password]
      if @user = User.authenticate(params[:user][:username], params[:user][:password]) 
        set_login_cookie(@user.get_psv)        
        if Mailbox.exists?(:client_id => @user.client_id)
          redirect_to mailboxes_path
        else
          redirect_to(mailbox(:new))
        end
        return
      else
        flash[:error] = "Wrong username/password"
        render :login
        return
      end
    end  
    render :layout => "login"
  end
  
  def logout
    cookies.delete COOKIE_NAME if cookies[COOKIE_NAME]
    redirect_to "/"
  end

  def index
    if @current_user and @current_user["client_id"]
      @users = User.client_all(@current_user["client_id"])
      render :layout => false
    end
  end
end
