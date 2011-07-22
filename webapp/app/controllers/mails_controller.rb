class MailsController < ApplicationController
  # GET /mails
  # GET /mails.xml
  def index
    page = params[:page] ? (params[:page].to_i-1)*PER_PAGE : 0
    @total   = Ticket.count(:conditions => {:client_id => @client.id, :mailbox_id => params[:mailbox_id]})
    @tickets = Ticket.find(:all, :include => [{:mails => {:froms => :person}}],
                         :conditions => {:client_id => @client.id, :mailbox_id => params[:mailbox_id]}, 
                         :order => "last_mail_at DESC", :limit => PER_PAGE, :offset => page)
    respond_to do |format|
      format.html{
        if request.xhr?
          render :layout => false
        else
          render "index"
        end
      }
      format.xml  { render :xml => @mails }
    end
  end

  # GET /mails/1
  # GET /mails/1.xml
  def show    
    unless @ticket = Ticket._get(params[:id])
      return
    end
    @thread_objects = []
    
    mails = @ticket.mails
    @users = User.client_all(@current_user["client_id"])      
    counter=0      
    mails.each{|mail|
      if mail.status==1
        counter+=mail.toggleStatus 
        mail.save
      end
    }
    @mailbox = mails.first.mailbox
    if counter>0
      @mailbox.unread_count = Mail.count(:conditions => {:status => 1, :mailbox_id => @mailbox.id})
      @mailbox.save
    end
    
    mails.each{|mail| @thread_objects << mail}
    @subject = mails[-1].subject
    @mails_length = mails.length
    
    #Getting notes
    @ticket.notes.each{|note| @thread_objects << note}
    @notes_length = @thread_objects.length - @mails_length
    
    #sort the mails and notes
    @thread_objects = @thread_objects.sort_by{|m| m.date}.reverse
      
    #get tags 
    @tags = @ticket.tags.sort_by{|t| t.name}

    respond_to do |format|
      format.html{
        if request.xhr?          
          render :partial => "mails/show", :layout => false
        else
          render "show"
        end
      }
      format.xml  { render :xml => @mail }
    end
  end

  # GET /mails/new
  # GET /mails/new.xml
  def new
    @mail = Mail.new
    if params[:ticket_id]
      @reply_all = true if params[:type] and params[:type]=="reply_all"
      @ticket          = Ticket.find(params[:ticket_id])
      last_mail_ticket = MailTicket.find(:first, :conditions => {:ticket_id => @ticket.id}, :limit => 1, :order => "created_at DESC")
      @last_mail       = Mail.find(last_mail_ticket.mail_id)
    end
    respond_to do |format|
      format.html { render :layout => false}# new.html.erb
      format.xml  { render :xml => @mail }
    end
  end

  # GET /mails/1/edit
  def edit
    @mail = Mail.find(params[:id])
  end

  # POST /mails
  # POST /mails.xml
  def create
    last_mail = Mail.find(params[:replied_to_email], :include => [:mailbox]) if params[:replied_to_email]
    mailbox   = last_mail.mailbox
    newmail, message_id   = Mail.send_mail(params, mailbox, last_mail)           
    @mail     = Mail.new(:raw_email => newmail, :client => @client, :mailbox_id => last_mail.mailbox_id, :subject => params[:mails][:subject],
                         :message_id => message_id, :date => Time.now, :in_reply_id => last_mail.id)
    if @mail.save
      #tos
      params[:mails][:tos].split(",").each{|from|
        Receiver.create(:mail_id => @mail.id, :person_id => getPerson(from).id, :receiver_type_id => 2)
      } if params[:mails][:tos]
      #ccs
      params[:mails][:ccs].split(",").each{|from|
        Receiver.create(:mail_id => @mail.id, :person_id => getPerson(from).id, :receiver_type_id => 3)
      } if params[:mails][:ccs]
      #bccs
      params[:mails][:bccs].split(",").each{|from|
        Receiver.create(:mail_id => @mail.id, :person_id => getPerson(from).id, :receiver_type_id => 4)
      } if params[:mails][:bccs]
      #from
      Receiver.create(:mail_id => @mail.id, :person_id => Person.find_by_email(mailbox.email).id, :receiver_type_id => 1)
      respond_to do |format|
        format.html { render :text => "sent successfully"}
        format.xml  { render :xml => @mail, :status => :created, :location => @mail }
      end
    else
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @mail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /mails/1
  # PUT /mails/1.xml
  def update
    @mail = Mail.find(params[:id])

    respond_to do |format|
      if @mail.update_attributes(params[:mail])
        flash[:notice] = 'Mail was successfully updated.'
        format.html { redirect_to(@mail) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /mails/1
  # DELETE /mails/1.xml
  def destroy
    @mail = Mail.find(params[:id])
    @mail.destroy

    respond_to do |format|
      format.html { redirect_to(mails_url) }
      format.xml  { head :ok }
    end
  end
  
  def mark_as_read
    mail = Mail.find(params[:id])
    mail.toggleStatus
    mail.save
    render :text => mail.status
  end

  private
  def getPerson(email)
    if Person.exists?(:email => email)
      person = Person.find_by_email(email)
    else
      person = Person.create(:email => email, :name => email)
    end
    return person
  end
end
