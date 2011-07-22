class Client < ActiveRecord::Base
  property :id, :integer, :nullable => false, :primary => true
  property :name, :string, :nullable => true
  property :company_id, :integer, :nullable => true
  property :subdomain, :string, :nullable => true
  property :created_at, :datetime, :nullable => true
  property :updated_at, :datetime, :nullable => true
  validates_presence_of :subdomain
  validates_uniqueness_of :subdomain

  has_many :people
  has_many :users
  has_many :notes
  belongs_to  :company
  has_many :mailboxes
  has_many :mails

  accepts_nested_attributes_for :people
  accepts_nested_attributes_for :users


  def complete_user
    user   = self.users.first
    person = self.people.first
    user.person_id = person.id
    user.role_id   = 1
    user.status    = 1
    user.save
    return user
  end
end
