class ContactEmail < ActiveRecord::Base
  property :id, :integer, :nullable => false, :primary => true
  property :person_id, :integer, :nullable => true
  property :email, :string, :nullable => true
  property :type, :integer, :nullable => true
  property :created_at, :datetime, :nullable => true
  property :updated_at, :datetime, :nullable => true
  belongs_to :person
end
