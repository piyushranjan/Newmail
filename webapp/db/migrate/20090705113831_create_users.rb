class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :person_id
      t.integer :role_id
      t.integer :client_id
      t.string :username
      t.string :password_hash
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
