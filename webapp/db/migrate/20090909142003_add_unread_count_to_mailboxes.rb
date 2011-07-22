class AddUnreadCountToMailboxes < ActiveRecord::Migration
  def self.up
    add_column :mailboxes, :unread_count, :integer
    add_index "mailboxes", ["unread_count"], :name => "mailboxes_unread_count"
  end

  def self.down
    drop_column :mailboxes, :unread_count
    drop_index "mailboxes_unread_count"
  end
end
