class CreateReceivers < ActiveRecord::Migration
  def self.up
    create_table :receivers do |t|
      t.integer :mail_id
      t.integer :receiver_type_id
      t.integer :person_id
      t.timestamps
    end
  end

  def self.down
    drop_table :receivers
  end
end
