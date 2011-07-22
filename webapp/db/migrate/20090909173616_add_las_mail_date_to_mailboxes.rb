class AddLasMailDateToMailboxes < ActiveRecord::Migration
  def self.up
    add_column :tickets, :last_mail_at, :datetime
    add_index  :tickets, [:last_mail_at], :name => "mailboxes_last_mail_at"
  end

  def self.down
    drop_column :mailboxes, :last_mail_at
    drop_index "mailboxes_last_mail_at"
  end
end
