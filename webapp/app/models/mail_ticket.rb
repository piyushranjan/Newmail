class MailTicket < ActiveRecord::Base
  property :id, :integer, :nullable => false, :primary => true
  property :ticket_id, :integer, :nullable => true
  property :mail_id, :integer, :nullable => true
  property :serial_number, :integer, :nullable => true
  property :created_at, :datetime, :nullable => true
  property :updated_at, :datetime, :nullable => true
  belongs_to :mail
  belongs_to :ticket, :counter_cache => true
  after_create :set_last_mail_at

  def set_last_mail_at
    ticket  = self.ticket
    ticket.last_mail_at = self.mail.date
    ticket.save
  end
end
