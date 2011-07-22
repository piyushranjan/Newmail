class CreateMailTickets < ActiveRecord::Migration
  def self.up
    create_table :mail_tickets do |t|
      t.integer :ticket_id
      t.integer :mail_id
      t.integer :serial_number
      t.timestamps
    end
    add_index "mail_tickets", ["ticket_id"], :name => "mail_tickets_ticket_id"
    add_index "mail_tickets", ["mail_id"], :name => "mail_tickets_mail_id"
    add_index "mail_tickets", ["serial_number"], :name => "mail_tickets_serial_number"
    add_index "mail_tickets", ["mail_id", "ticket_id"], :name => "mail_tickets_mail_id_ticket_id"
  end

  def self.down
    drop_table :mail_tickets
  end
end
