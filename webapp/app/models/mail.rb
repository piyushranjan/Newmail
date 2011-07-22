require "ftools"
require "uuid"
class Mail < ActiveRecord::Base
  property :id, :integer, :nullable => false, :primary => true
  property :message_id, :string, :nullable => true
  property :domain, :string, :nullable => true
  property :mailbox_id, :integer, :nullable => true
  property :subject, :string, :nullable => true
  property :in_reply_id, :integer, :nullable => true
  property :user_agent_id, :integer, :nullable => true
  property :content_type_id, :integer, :nullable => true
  property :date, :datetime, :nullable => true
  property :priority_id, :integer, :nullable => true
  property :client_id, :integer, :nullable => true
  property :created_at, :datetime, :nullable => true
  property :updated_at, :datetime, :nullable => true
  property :status, :integer, :nullable => true
  attr_accessor :raw_email
  belongs_to :content_type
  belongs_to :client
  belongs_to :user_agent
  belongs_to :priority
  belongs_to :mailbox, :counter_cache => true

  has_many :receivers
  has_many :froms, :class_name => "Receiver", :conditions => "receiver_type_id=1"
  has_many :tos, :class_name => "Receiver", :conditions => "receiver_type_id=2"
  has_many :ccs, :class_name => "Receiver", :conditions => "receiver_type_id=3"
  has_many :bccs, :class_name => "Receiver", :conditions => "receiver_type_id=4"
  has_many :in_reply_tos, :class_name => "Person"
  has_one :mail_ticket
  has_one :ticket, :through => :mail_ticket

  validates_presence_of :date
  validates_presence_of :client
  validates_presence_of :mailbox
  validates_presence_of :message_id
  validates_uniqueness_of :message_id
  after_create :save_raw_email, :create_or_update_thread
  @@uuid = UUID.new

  def save_raw_email
    if self.id
      File.makedirs(File.join(RAILS_ROOT, "../mails_store/mails/#{self.client_id}/#{self.mailbox_id}"))
      File.open(File.join(RAILS_ROOT, "../mails_store/mails/#{self.client_id}/#{self.mailbox_id}/#{self.id}"), 'w') do |f|
        f.write self.raw_email
      end
      mailbox = self.mailbox
      mailbox.unread_count = Mail.count(:conditions => {:status => self.status, :mailbox_id => self.mailbox_id})
      mailbox.save
    end
  end

  def find_raw
    if File.exists?("#{RAILS_ROOT}/../mails_store/mails/#{self.client_id}/#{self.mailbox_id}/#{self.id}")
      TMail::Mail.parse(File.read("#{RAILS_ROOT}/../mails_store/mails/#{self.client_id}/#{self.mailbox_id}/#{self.id}"))
    elsif self.raw_email
      TMail::Mail.parse(self.raw_email)
    else
      raise NoMailFound
    end
  end

  def create_or_update_thread
    mail = self.find_raw
    #Create ticket/entry into thread only if not present
    if not MailTicket.exists?(:mail_id => self.id)
      if mail.in_reply_to
        #Try to find a parent thread only if there is a in_reply_to!
        if parent = Mail.find_by_message_id(mail.in_reply_to)
          #Parent exists. We now need to create a MailTicket entry if ticket exists
          if mail_ticket = MailTicket.find_by_mail_id(parent.id)
            max_serial_number = MailTicket.find(:first, :conditions => {:ticket_id => mail_ticket.ticket_id}, 
                                                :order => "serial_number DESC", :limit => 1).serial_number
            MailTicket.create(:mail_id => self.id, :ticket_id => mail_ticket.ticket_id, :serial_number => max_serial_number+1)
          else
            #create mail ticket for parent
            parent.create_or_update_thread
          end
        else
          #Orphan mail. This mail becomes the parent as actual parent is absent from the system
          create_new_ticket
        end
      else
        #no reply to create a new thread
        create_new_ticket
      end
    end
  end

  def create_new_ticket
    ticket = Ticket.create(:start_mail_id => self.id, :client_id => self.client_id, :mailbox_id => self.mailbox_id, :last_mail_at => Time.now, :status => 1)
    MailTicket.create(:mail_id => self.id, :ticket_id => ticket.id, :serial_number => 1)
  end

  def find_or_create_parent_mail_ticket(mail)
    # Try to find a parent thread only if there is a in_reply_to!
    if mail.in_reply_to
      if Mail.exists?(:message_id => mail.in_reply_to)
        # Parent exists. We just have to create a MailTicket entry if ticket exists
        parent = Mail.find_by_message_id(mail.in_reply_to)
        ticket = MailTicket.find_by_mail_id(parent.id)
        max_serial_number = MailTicket.find(:first, :conditions => {:ticket_id => ticket.id}, :order => "serial_number DESC", :limit => 1).serial_number
        MailTicket.create(:mail_id => self.id, :ticket_id => ticket.id, :serial_number => max_serial_number)
      else
        #Orphan mail. This mail becomes the parent as actual parent is absent from the system

      end
    end
  end

  def self.getmail(mailbox)
    imap = Net::IMAP.new(mailbox.host,'993', true)
    imap.login(mailbox.username, mailbox.password)
    imap.select('INBOX')
    imap.search(["NOT", "DELETED"]).each do |message_id|
      envelope = imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
      puts "#{envelope.from[0].name}: \t#{envelope.subject}"
    end
    imap.logout()
    imap.disconnect()
  end

  def toggleStatus
    if self.status==1
      self.status = 2
      return 1
    else
      return 0
    end
  end

  def self.send_mail(params, mailbox, in_reply_to=nil)
    mail = TMail::Mail.new
    mail.to = params[:mails][:tos]
    mail.from = mailbox.email
    mail.subject = params[:mails][:subject]
    mail.date = Time.now
    mail.reply_to = mailbox.email
    message_id = "<#{@@uuid.generate}@#{mailbox.hostname}>"
    mail.message_id = message_id
    mail.in_reply_to = in_reply_to.message_id if in_reply_to

    mail.body = params[:mails][:body]

    Net::SMTP.start(mailbox.hostname, 25, mailbox.hostname, mailbox.username, mailbox.password, :login ) do|smtpclient|
      smtpclient.send_message(
                              mail.to_s,
                              mail.from,
                              mail.to
                              )
    end
    return [mail, message_id]
  end
end




