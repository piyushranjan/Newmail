class TaggedObject < ActiveRecord::Base
  property :id, :integer, :nullable => false, :primary => true
  property :tag_id, :integer, :nullable => true
  property :object_id, :integer, :nullable => true
  property :object_type, :string, :nullable => true
  property :created_at, :datetime, :nullable => true
  property :updated_at, :datetime, :nullable => true
  belongs_to :ticket, :foreign_key => :object_id, :conditions => {:object_type => "ticket"}
  belongs_to :tag
  validates_presence_of :tag_id
  validates_presence_of :object_id
  validates_presence_of :object_type
end
