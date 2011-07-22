class AddTrashAndJunkToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :is_trashed, :boolean, :default => false
    add_column :tickets, :is_junked,  :boolean, :default => false    
  end

  def self.down
    drop_column :tickets, :is_trashed, :default => false
    drop_column :tickets, :is_junked,  :default => false    
  end
end
