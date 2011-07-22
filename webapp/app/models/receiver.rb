class Receiver < ActiveRecord::Base
  property :id, :integer, :nullable => false, :primary => true
  property :mail_id, :integer, :nullable => true
  property :receiver_type_id, :integer, :nullable => true
  property :person_id, :integer, :nullable => true
  property :created_at, :datetime, :nullable => true
  property :updated_at, :datetime, :nullable => true
  belongs_to :mail
  belongs_to :person
end
