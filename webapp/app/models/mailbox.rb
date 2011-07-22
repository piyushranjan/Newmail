class Mailbox < ActiveRecord::Base
  property :id, :integer, :nullable => false, :primary => true
  property :client_id, :integer, :nullable => true
  property :email, :string, :nullable => true
  property :name, :string, :nullable => true
  property :hostname, :string, :nullable => true
  property :server_type, :string, :nullable => true
  property :username, :string, :nullable => true
  property :password, :string, :nullable => true
  property :created_at, :datetime, :nullable => true
  property :updated_at, :datetime, :nullable => true
  property :mails_count, :integer, :nullable => true
  property :unread_count, :integer, :nullable => true
  property :smtp_server, :string, :nullable => true
  belongs_to :client
  has_many :mails
  validates_presence_of :client
  validates_presence_of :email
  validates_presence_of :name
  validates_presence_of :hostname
  validates_presence_of :server_type
  validates_presence_of :username
  validates_presence_of :password

  def self._get(params, client, current_user)
    page = params[:page] ? (params[:page].to_i-1)*PER_PAGE : 0
    if /\d+/.match(params[:mailbox])
      total   = Ticket.count(:conditions => {:mailbox_id => params[:mailbox]})
      tickets = Ticket.find(:all, :include => [{:mails => {:froms => :person}}],
                             :conditions => {:client_id => client.id, :mailbox_id => params[:mailbox]},
                             :order => "last_mail_at DESC", :limit => PER_PAGE, :offset => page)
    elsif params[:mailbox]=="all"
      total   = Ticket.count(:conditions => {:client_id => client.id})
      tickets = Ticket.find(:all, :include => [{:mails => {:froms => :person}}], :conditions => {:client_id => client.id},
                           :order => "last_mail_at DESC", :limit => PER_PAGE, :offset => page)
    elsif params[:mailbox]=="assigned"
      total   = Ticket.count(:conditions => {:client_id => client.id, :assigned_to_id => current_user["id"]})
      tickets = Ticket.find(:all, :include => [{:mails => {:froms => :person}}],
                             :conditions => {:client_id => client.id, :assigned_to_id => current_user["id"]},
                             :order => "last_mail_at DESC", :limit => PER_PAGE, :offset => page)
    elsif params[:mailbox]=="closed"
      total   = Ticket.count(:conditions => {:client_id => client.id, :status => 3})
      tickets = Ticket.find(:all, :include => [{:mails => {:froms => :person}}],
                             :conditions => {:client_id => client.id, :status => 3},
                             :order => "last_mail_at DESC", :limit => PER_PAGE, :offset => page)
    elsif params[:mailbox]=="junked"
      total   = Ticket.send(:with_exclusive_scope){ Ticket.count(:conditions => {:client_id => client.id, :is_trashed => true})}
      tickets = Ticket.send(:with_exclusive_scope){
        Ticket.find(:all, :include => [{:mails => {:froms => :person}}],
                    :conditions => {:client_id => client.id, :is_junked => true},
                    :order => "last_mail_at DESC", :limit => PER_PAGE, :offset => page)
      }
    elsif params[:mailbox]=="trashed"
      total   = Ticket.send(:with_exclusive_scope){
        Ticket.count(:conditions => {:client_id => client.id, :is_junked => true, :mailbox_id => params[:id]}.reject{|k, v| v.blank?})
      }
      tickets = Ticket.send(:with_exclusive_scope){
        Ticket.find(:all, :include => [{:mails => {:froms => :person}}],
                    :conditions => {:client_id => client.id, :is_trashed => true, :mailbox_id => params[:id]}.reject{|k, v| v.blank?},
                    :order => "last_mail_at DESC", :limit => PER_PAGE, :offset => page)
      }
    end
    return [total, tickets]
  end
end
