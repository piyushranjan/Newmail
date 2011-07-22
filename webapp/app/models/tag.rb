class Tag < ActiveRecord::Base
  property :id, :integer, :nullable => false, :primary => true
  property :name, :string, :nullable => true
  property :created_at, :datetime, :nullable => true
  property :updated_at, :datetime, :nullable => true
  property :client_id, :integer, :nullable => true
  has_many :tagged_objects
  has_many :tickets, :through => :tagged_objects
  validates_presence_of :name
  validates_presence_of :client_id
  validates_length_of :name, :minimum => 3
  validates_length_of :name, :maximum => 30

  def self.tag_ticket(params, client)
    if Ticket.exists?(:id => params[:ticket_id])
      ticket = Ticket.find(params[:ticket_id])
      name = params[:name].strip
      tag = exists?(:name => name) ? find_by_name(name) : create(:name => name, :client_id => client.id)

      if not TaggedObject.exists?(:tag_id => tag.id, :object_id => ticket.id, :object_type => "ticket")
        return [TaggedObject.new(:tag_id => tag.id, :object_id => ticket.id, :object_type => "ticket"), ticket]
      else
        return [false, ticket]
      end
    else
      return [false, false]
    end
  end
end
