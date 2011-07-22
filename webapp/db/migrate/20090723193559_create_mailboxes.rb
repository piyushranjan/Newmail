class CreateMailboxes < ActiveRecord::Migration
  def self.up
    create_table :mailboxes do |t|
      t.integer :client_id
      t.string :email
      t.string :name
      t.string :hostname
      t.string :server_type
      t.string :username
      t.string :password
      t.timestamps
    end
  end

  def self.down
    drop_table :mailboxes
  end
end
