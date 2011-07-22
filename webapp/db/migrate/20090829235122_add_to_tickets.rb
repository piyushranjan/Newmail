class AddToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :mail_tickets_count, :integer    
  end

  def self.down
    drop_column :tickets, :mails_count    
  end
end
