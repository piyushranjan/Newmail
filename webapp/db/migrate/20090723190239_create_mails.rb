class CreateMails < ActiveRecord::Migration
  def self.up
    create_table :mails do |t|
      t.string :message_id
      t.string :domain
      t.integer :mailbox_id
      t.string :subject
      t.integer :in_reply_id
      t.integer :user_agent_id
      t.integer :content_type_id
      t.datetime :date
      t.integer :priority_id
      t.integer :client_id

      t.timestamps
    end
  end

  def self.down
    drop_table :mails
  end
end
