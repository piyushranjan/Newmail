class AddSmtpToMailbox < ActiveRecord::Migration
  def self.up
    add_column :mailboxes, :smtp_server, :string
  end

  def self.down
    drop_column :mailboxes, :smtp_server
  end
end
