class AddToMailboxes < ActiveRecord::Migration
  def self.up
    add_column :mailboxes, :mails_count, :integer
  end

  def self.down
    drop_column :mailboxes, :mails_count
  end
end
