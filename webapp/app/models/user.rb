class User < ActiveRecord::Base
  property :id, :integer, :nullable => false, :primary => true
  property :person_id, :integer, :nullable => true
  property :role_id, :integer, :nullable => true
  property :client_id, :integer, :nullable => true
  property :username, :string, :nullable => true
  property :password_hash, :string, :nullable => true
  property :status, :integer, :nullable => true
  property :created_at, :datetime, :nullable => true
  property :updated_at, :datetime, :nullable => true
  attr_accessor :password1, :password2
  validates_presence_of :username
#  validates_presence_of :password_hash
  validates_uniqueness_of :username, :scope => [:client_id]
  validate :passwords_exist_and_match

  has_many :notes
  belongs_to :client
  belongs_to :person
  before_validation :set_password_hash

  def passwords_exist_and_match
    if password1.length==0 or password2.length==0 or password1!=password2
      errors.add_to_base("Passwords cannot be blank")
    end
  end

  def set_password_hash
    self.password_hash = OpenSSL::Digest::SHA1.new(password1).hexdigest
  end

  def self.authenticate(username, password)
    return User.find(:first, :conditions => {:username => username, :password_hash => OpenSSL::Digest::SHA1.new(password).hexdigest})
  end

  def get_psv
    return Marshal.dump(self)
  end

  def name
    return "#{first_name} #{last_name}"
  end

  def self.client_all(client_id)
    return(User.find(:all, :conditions => {:client_id => client_id, :status => 1},
                     :select => "users.id, users.username, users.person_id"))
  end
end
