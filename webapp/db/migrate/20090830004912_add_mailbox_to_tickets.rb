class AddMailboxToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :mailbox_id, :integer
    add_index  "tickets", ["mailbox_id"], :name => "tickets_mailbox_id"
  end

  def self.down
    drop_index "tickets_mailbox_id"
    drop_column :tickets, :mailbox_id
  end
end
