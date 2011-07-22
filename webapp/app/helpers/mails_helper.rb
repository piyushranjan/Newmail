module MailsHelper
  def ticket_statuses_select(status)
    TICKET_STATUSES.collect{|k, v|
      "<option #{"selected=\"selected\"" if status==k} value=\"#{k}\">#{v.capitalize}</option>" if k!=nil
    }
  end
  
  def get_users(user)
    User.client_all(@current_user["client_id"]).collect{|user|
      "<option #{"selected=\"selected\"" if @ticket.assigned_to_id and user and user.id==@ticket.assigned_to_id} value=\"#{user.id}\">#{user.username}</option>"      
    }
  end
end
