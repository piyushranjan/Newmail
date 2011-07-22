class Company < ActiveRecord::Base
  property :id, :integer, :nullable => false, :primary => true
  property :name, :string, :nullable => true
  property :created_at, :datetime, :nullable => true
  property :updated_at, :datetime, :nullable => true
  belongs_to :clients
end
