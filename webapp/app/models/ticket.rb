class Ticket < ActiveRecord::Base
  property :id, :integer, :nullable => false, :primary => true
  property :start_mail_id, :integer, :nullable => true
  property :name, :string, :nullable => true
  property :status, :integer, :nullable => true
  property :assigned_to_id, :integer, :nullable => true
  property :client_id, :integer, :nullable => true
  property :created_at, :datetime, :nullable => true
  property :updated_at, :datetime, :nullable => true
  property :mail_tickets_count, :integer, :nullable => true
  property :mailbox_id, :integer, :nullable => true
  property :last_mail_at, :datetime, :nullable => true
  property :is_trashed, :boolean, :nullable => true
  property :is_junked, :boolean, :nullable => true
  default_scope :conditions => {:is_trashed => false, :is_junked => false}
  named_scope :junked, :conditions => {:is_junked => true}, :include => [{:mails => {:froms => :person}}], :order => "last_mail_at DESC", :limit => PER_PAGE
  named_scope :trashed, :conditions => {:is_trashed => true}, :include => [{:mails => {:froms => :person}}], :order => "last_mail_at DESC", :limit => PER_PAGE
  has_many :mail_tickets
  has_many :notes, :foreign_key => :parent_id, :conditions => {:parent_type => "ticket"}
  has_many :tagged_objects, :foreign_key => :object_id, :conditions => {:object_type => "ticket"}
  has_many :tags, :through => :tagged_objects
  has_many :mails, :through => :mail_tickets
  belongs_to :first_mail, :foreign_key => :start_mail_id, :class_name => "Mail"

  validates_presence_of :start_mail_id
  validates_presence_of :client_id
  validates_presence_of :mailbox_id

  before_save :set_status

  def set_status
    if self.assigned_to_id.nil? and self.status==2
      #if status is assigned and not assigned to anybody then make it Open
      self.status=1
    end
    self.assigned_to_id=0 if self.status==3
  end

  def self.junk_or_trash(params, client, direction)
    params[:ticket_ids] = params[:ticket_ids].collect{|x| x.to_i}
    params[:ticket_ids].each{|ticket_id|
      if Ticket.exists?(:id => ticket_id)
        ActiveRecord::Base.transaction do
          t = Ticket.find(ticket_id)
          t.status = 3
          t.assigned_to_id=nil
          if direction==:junk
            t.is_junked = true
            t.is_trashed = false
          else
            t.is_junked = false
            t.is_trashed = true
          end
          t.save
        end
      end
    }
    conditions = if params[:mailbox_id] and params[:mailbox_id].to_i>0
                   ["client_id = ? and id < ? and mailbox_id=?", client.id, params[:last_mail_id], params[:mailbox_id]]
                 else
                   ["client_id = ? and id < ?", client.id, params[:last_mail_id]]
                 end
    Ticket.find(:all, :include => [{:mails => {:froms => :person}}],
                :conditions => conditions,
                :order => "last_mail_at DESC", :limit => params[:ticket_ids].length)
  end

  def self._get(id)
    if Ticket.with_exclusive_scope{Ticket.exists?(:id => id)}
      return @ticket = Ticket.with_exclusive_scope{
        Ticket.find(id, :include => [{:mails => {:froms => :person}}])
      }
    else
      false
    end
  end
end
