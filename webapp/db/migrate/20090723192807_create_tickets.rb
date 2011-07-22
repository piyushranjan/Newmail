class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.integer :start_mail_id
      t.string :name
      t.integer :status
      t.integer :assigned_to_id
      t.integer :client_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
