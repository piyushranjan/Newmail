class ClientsController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create]
  layout "login"
  # GET /people/1
  # GET /people/1.xml
  def show
    @client = Client.find(@current_user["client_id"])

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @client }
    end
  end

  # GET /clients/new
  # GET /clients/new.xml  
  def new
    #redirect to mailbox if already logged in
    if @current_user
      redirect_to(mailboxes_path())
      return
    end 
    @client  = Client.new
    @client.users.build
    @client.people.build
    @client.company
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @client }
    end
  end

  # POST /clients
  # POST /clients.xml
  def create
    @client = Client.new(params[:client])
    respond_to do |format|
      if @client.save
        @user = @client.complete_user
        flash[:notice] = 'Client was successfully created.'
        set_login_cookie(@user.get_psv)
        format.html { redirect_to(settings_path()) }
        format.xml  { render :xml => @client, :status => :created, :location => @client }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end
end
