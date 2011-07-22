class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.integer :parent_id
      t.string :parent_type
      t.text :note
      t.integer :user_id
      t.integer :client_id

      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
