class Person < ActiveRecord::Base
  property :id, :integer, :nullable => false, :primary => true
  property :email, :string, :nullable => true
  property :name, :string, :nullable => true
  property :client_id, :integer, :nullable => true
  property :created_at, :datetime, :nullable => true
  property :updated_at, :datetime, :nullable => true
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :name

  belongs_to :client
  has_one :user
  has_many :receivers

  has_many :contact_phones
  has_many :contact_emails
  has_many :contact_ims
  has_many :contact_addresses
  has_many :contact_urls


  def self.find_or_create(email, client)
    address = (email.class==TMail::Address and email.address ? email.address : email)
    name    = (email.class==TMail::Address and email.name    ? email.name    : email)

    if Person.exists?(:email => address, :client_id => client.id)
       return Person.find(:first, :conditions => {:email => address, :client_id => client.id})
    else
      return Person.create(:email => address, :name => name||address, :client_id => client.id)
    end
  end
end
