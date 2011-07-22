# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091023161002) do

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_addresses", :force => true do |t|
    t.integer  "person_id"
    t.string   "address"
    t.integer  "city_id"
    t.integer  "country_id"
    t.integer  "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_emails", :force => true do |t|
    t.integer  "person_id"
    t.string   "email"
    t.integer  "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_ims", :force => true do |t|
    t.integer  "person_id"
    t.string   "url"
    t.integer  "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_phones", :force => true do |t|
    t.integer  "person_id"
    t.string   "phone_number"
    t.integer  "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_urls", :force => true do |t|
    t.integer  "person_id"
    t.string   "url"
    t.integer  "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mail_tickets", :force => true do |t|
    t.integer  "ticket_id"
    t.integer  "mail_id"
    t.integer  "serial_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mail_tickets", ["mail_id", "ticket_id"], :name => "mail_tickets_mail_id_ticket_id"
  add_index "mail_tickets", ["mail_id"], :name => "mail_tickets_mail_id"
  add_index "mail_tickets", ["serial_number"], :name => "mail_tickets_serial_number"
  add_index "mail_tickets", ["ticket_id"], :name => "mail_tickets_ticket_id"

  create_table "mailboxes", :force => true do |t|
    t.integer  "client_id"
    t.string   "email"
    t.string   "name"
    t.string   "hostname"
    t.string   "server_type"
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mails_count"
    t.integer  "unread_count"
    t.string   "smtp_server"
  end

  add_index "mailboxes", ["client_id"], :name => "mailboxes_client_id"
  add_index "mailboxes", ["email"], :name => "mailboxes_email"
  add_index "mailboxes", ["unread_count"], :name => "mailboxes_unread_count"

  create_table "mails", :force => true do |t|
    t.string   "message_id"
    t.string   "domain"
    t.integer  "mailbox_id"
    t.string   "subject"
    t.integer  "in_reply_id"
    t.integer  "user_agent_id"
    t.integer  "content_type_id"
    t.datetime "date"
    t.integer  "priority_id"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",          :default => 1
  end

  add_index "mails", ["client_id"], :name => "mail_client_id"
  add_index "mails", ["created_at"], :name => "mail_created_at"
  add_index "mails", ["date"], :name => "mail_date"
  add_index "mails", ["in_reply_id"], :name => "mail_in_reply_id"
  add_index "mails", ["mailbox_id"], :name => "mail_mailbox_id"
  add_index "mails", ["message_id"], :name => "mail_message_id"
  add_index "mails", ["status"], :name => "mail_status"

  create_table "notes", :force => true do |t|
    t.integer  "parent_id"
    t.string   "parent_type"
    t.text     "note"
    t.integer  "user_id"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people", ["client_id"], :name => "people_client_id"
  add_index "people", ["email"], :name => "people_email"
  add_index "people", ["name"], :name => "people_name"

  create_table "priorities", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receivers", :force => true do |t|
    t.integer  "mail_id"
    t.integer  "receiver_type_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "receivers", ["mail_id"], :name => "receivers_mail_id"
  add_index "receivers", ["person_id"], :name => "receivers_person_id"
  add_index "receivers", ["receiver_type_id"], :name => "receivers_receiver_type_id"

  create_table "tagged_objects", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "object_id"
    t.string   "object_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tagged_objects", ["object_id"], :name => "tagged_objects_object_id"
  add_index "tagged_objects", ["object_type"], :name => "tagged_objects_object_type"
  add_index "tagged_objects", ["tag_id"], :name => "tagged_objects_tag_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
  end

  add_index "tags", ["name"], :name => "tags_name"

  create_table "tickets", :force => true do |t|
    t.integer  "start_mail_id"
    t.string   "name"
    t.integer  "status"
    t.integer  "assigned_to_id"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mail_tickets_count"
    t.integer  "mailbox_id"
    t.datetime "last_mail_at"
    t.boolean  "is_trashed",         :default => false
    t.boolean  "is_junked",          :default => false
  end

  add_index "tickets", ["assigned_to_id"], :name => "ticket_assigned_to_id"
  add_index "tickets", ["client_id"], :name => "ticket_client_id"
  add_index "tickets", ["last_mail_at"], :name => "mailboxes_last_mail_at"
  add_index "tickets", ["mailbox_id"], :name => "tickets_mailbox_id"
  add_index "tickets", ["start_mail_id"], :name => "ticket_start_mail_id"
  add_index "tickets", ["status"], :name => "ticket_status"

  create_table "user_agents", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "person_id"
    t.integer  "role_id"
    t.integer  "client_id"
    t.string   "username"
    t.string   "password_hash"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
