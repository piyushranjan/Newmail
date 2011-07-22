class AddClientIdToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :client_id, :integer
  end

  def self.down
    drop_column :tags, :client_id
  end
end
