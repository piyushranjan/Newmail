class AddToMails < ActiveRecord::Migration
  def self.up
    add_column :mails, :status, :integer, :default => 1
  end

  def self.down
    remove_column :mails, :status
  end
end
