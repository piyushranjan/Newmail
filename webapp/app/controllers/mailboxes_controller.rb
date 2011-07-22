class MailboxesController < ApplicationController
  # GET /mailboxes
  # GET /mailboxes.xml
  def index
    params[:mailbox] = "all"
    @total, @tickets = Mailbox._get(params, @client, @current_user)
    @assigned_count = Ticket.count(:conditions => {:assigned_to_id => @current_user["id"]})
    respond_to do |format|
      format.html{
        if request.xhr?
          render :partial => "mailboxes/mail"
        else
          render
        end
      }
      format.xml  { render :xml => @mailboxes }
    end
  end

  # GET /mailboxes/1
  # GET /mailboxes/1.xml
  def show
    @total, @tickets = Mailbox._get(params, @client, @current_user)
    respond_to do |format|
      format.html{
        request.xhr? ? render(:partial => "mail", :layout => false) : render("index")
      }
      format.xml  { render :xml => @mailbox }
    end
  end

  # GET /mailboxes/new
  # GET /mailboxes/new.xml
  def new    
    @mailbox = Mailbox.new

    respond_to do |format|
      format.html{
        render :layout => "login"
      }# new.html.erb
      format.xml  { render :xml => @mailbox }
    end
  end

  # GET /mailboxes/1/edit
  def edit
    @mailbox = Mailbox.find(params[:id])
  end

  # POST /mailboxes
  # POST /mailboxes.xml
  def create
    @mailbox = Mailbox.new(params[:mailbox])
    @mailbox.client_id = @client.id
    respond_to do |format|
      if @mailbox.save
        flash[:notice] = 'Mailbox was successfully created.'
        format.html { redirect_to(@client) }
        format.xml  { render :xml => @mailbox, :status => :created, :location => @mailbox }
      else
        format.html { render :action => "new", :layout => "login" }
        format.xml  { render :xml => @mailbox.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /mailboxes/1
  # PUT /mailboxes/1.xml
  def update
    @mailbox = Mailbox.find(params[:id])

    respond_to do |format|
      if @mailbox.update_attributes(params[:mailbox])
        flash[:notice] = 'Mailbox was successfully updated.'
        format.html { redirect_to(@mailbox) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mailbox.errors, :status => :unprocessable_entity }
      end
    end
  end

end
