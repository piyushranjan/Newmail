class Note < ActiveRecord::Base
  property :id, :integer, :nullable => false, :primary => true
  property :parent_id, :integer, :nullable => true
  property :parent_type, :string, :nullable => true
  property :note, :text, :nullable => true
  property :user_id, :integer, :nullable => true
  property :client_id, :integer, :nullable => true
  property :created_at, :datetime, :nullable => true
  property :updated_at, :datetime, :nullable => true
  belongs_to :user
  belongs_to :client
  validates_presence_of :client_id, :message => "You cannot add this note"
  validates_presence_of :user_id, :message => "You cannot add this note"
  validates_presence_of :note, :message => "No note to be added"
  validates_presence_of :parent_id, :message => "Don't know where to add this note"
  validates_presence_of :parent_type, :message => "You cannot add this note here"
  validates_length_of :note, :minimum => 1, :too_short => "please enter at least {{count}} character"
  validates_length_of :note, :maximum => 1000, :too_long => "Whoa! Too long. only {{count}} characters allowed"

  def date
    self.created_at
  end
end
