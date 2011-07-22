class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :email
      t.string :name
      t.integer :client_id

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
