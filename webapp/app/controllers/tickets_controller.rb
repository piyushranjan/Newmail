class TicketsController < ApplicationController
  def assign
    if @current_user and params[:tickets] and params[:tickets].length>0      
      user = User.find(params[:user_id]) if params[:user_id] and User.exists?(:client_id => @client.id, :id => params[:user_id])
      Ticket.find(params[:tickets]).each{|ticket|
        ticket.assigned_to_id =  user ? user.id : nil
        ticket.status = user ? 2 : 1
        params[:tickets].delete(ticket.id.to_s) if not ticket.save
      }
      params[:tickets].length>1 ? render(:text => params[:tickets].join(",")) : render(:json => {:status => "2", :user_id => (user ? user.id : "0")})
    else
      render :text => "", :status => 403
    end
  end

  def changeStatus
    if @current_user and params[:tickets] and params[:tickets].length>0
      tickets = Ticket.find(params[:tickets]).collect{|ticket|
        ticket.status         = params[:status].to_i
        ticket if ticket.save
      }      
      tickets.length>1 ? render(:text => tickets.collect{|x| x.id}.join(",")) : render(:json => {:status => tickets[0].status, :user_id => params[:user_id]||"0"})
    else
      render :text => "", :status => 403      
    end
  end
  
  def junk
    @tickets = Ticket.junk_or_trash(params, @client, :junk)
    render :partial => "mails/mail_trs"
  end

  def trash
    @tickets = Ticket.junk_or_trash(params, @client, :trash)    
    render :partial => "mails/mail_trs"
  end
end
