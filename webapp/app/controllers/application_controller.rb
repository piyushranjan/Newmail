require "app/models/user.rb"
PER_PAGE = 20
WINDOW   = 1 
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include AuthSystem
#  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  prepend_before_filter :get_user_from_cookie, :login_required, :get_context

  def login_required
    redirect_to(:action => "login", :controller => "users") if not @current_user
  end
  
  def get_user_from_cookie
    user = get_user_from_login_cookie
    if not user.nil?
      @current_user = Marshal.load(user)
    end
  end

  def get_context
    @client = Client.find(@current_user["client_id"]) if @current_user
    [:client].each{|param|
      if not instance_variables.include?("@#{param}") and params["#{param}_id".to_sym]
        model = Kernel.const_get("#{param}".camelcase)
        instance_variable_set("@#{param}", model.find(params["#{param}_id".to_sym]))
      end
    }    
  end
end
