class AddIndexesToAll < ActiveRecord::Migration
  def self.up
    add_index "mails", ["message_id"], :name => "mail_message_id"
    add_index "mails", ["mailbox_id"], :name => "mail_mailbox_id"
    add_index "mails", ["in_reply_id"], :name => "mail_in_reply_id"
    add_index "mails", ["client_id"], :name => "mail_client_id"
    add_index "mails", ["date"], :name => "mail_date"
    add_index "mails", ["created_at"], :name => "mail_created_at"
    add_index "mails", ["status"], :name => "mail_status"
    add_index "tickets", ["start_mail_id"], :name => "ticket_start_mail_id"
    add_index "tickets", ["status"], :name => "ticket_status"
    add_index "tickets", ["assigned_to_id"], :name => "ticket_assigned_to_id"    
    add_index "tickets", ["client_id"], :name => "ticket_client_id"    
    add_index "people", ["client_id"], :name => "people_client_id"        
    add_index "people", ["email"], :name => "people_email"        
    add_index "people", ["name"], :name => "people_name"        
    add_index "receivers", ["mail_id"], :name => "receivers_mail_id"        
    add_index "receivers", ["person_id"], :name => "receivers_person_id"        
    add_index "receivers", ["receiver_type_id"], :name => "receivers_receiver_type_id"
    add_index "tags", ["name"], :name => "tags_name"
    add_index "tagged_objects", ["tag_id"], :name => "tagged_objects_tag_id"    
    add_index "tagged_objects", ["object_id"], :name => "tagged_objects_object_id"    
    add_index "tagged_objects", ["object_type"], :name => "tagged_objects_object_type"    
    add_index "mailboxes", ["client_id"], :name => "mailboxes_client_id"    
    add_index "mailboxes", ["email"], :name => "mailboxes_email"    
  end

  def self.down
  end
end
