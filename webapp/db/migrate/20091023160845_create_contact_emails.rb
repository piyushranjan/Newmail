class CreateContactEmails < ActiveRecord::Migration
  def self.up
    create_table :contact_emails do |t|
      t.integer :person_id
      t.string :email
      t.integer :type

      t.timestamps
    end
  end

  def self.down
    drop_table :contact_emails
  end
end
