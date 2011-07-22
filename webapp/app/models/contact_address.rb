class ContactAddress < ActiveRecord::Base
  property :id, :integer, :nullable => false, :primary => true
  property :person_id, :integer, :nullable => true
  property :address, :string, :nullable => true
  property :city_id, :integer, :nullable => true
  property :country_id, :integer, :nullable => true
  property :type, :integer, :nullable => true
  property :created_at, :datetime, :nullable => true
  property :updated_at, :datetime, :nullable => true
  belongs_to :person
end
