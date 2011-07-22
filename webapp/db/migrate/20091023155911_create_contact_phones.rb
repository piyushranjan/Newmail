class CreateContactPhones < ActiveRecord::Migration
  def self.up
    create_table :contact_phones do |t|
      t.integer :person_id
      t.string  :phone_number
      t.integer :type

      t.timestamps
    end
  end

  def self.down
    drop_table :contact_phones
  end
end
