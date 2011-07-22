class CreateContactAddresses < ActiveRecord::Migration
  def self.up
    create_table :contact_addresses do |t|
      t.integer :person_id
      t.string  :address
      t.integer :city_id
      t.integer :country_id
      t.integer :type

      t.timestamps
    end
  end

  def self.down
    drop_table :contact_addresses
  end
end
