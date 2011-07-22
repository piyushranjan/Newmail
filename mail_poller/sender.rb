#!/usr/bin/ruby
require "rubygems"
require "tmail"
require 'net/pop'
require 'net/smtp'
require "active_record"
require "yaml"
require "ftools"

RAILS_ROOT = File.join(File.dirname(__FILE__), "../webapp")
ActiveRecord::Base.establish_connection(YAML.load(File.read("#{RAILS_ROOT}/config/database.yml"))["development"])
Dir.glob(File.join(RAILS_ROOT, "app/models/*.rb")).each{|f| require f}

def getPerson(email)
  if Person.exists?(:email => email) 
    person = Person.find_by_email(email) 
  else
    person = Person.create(:email => email, :name => email) 
  end
  return person
end

while true
  Mailbox.all(:order => "created_at").each{|mailbox|
    begin
      port = 110
      if mailbox.hostname=="pop.gmail.com"
        port = 995 
        puts "Enabling ssl"
        Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)
      else
        Net::POP3.disable_ssl
      end
      puts "#{mailbox.username}  #{mailbox.hostname}:#{port}"
      counter = 0
      last_mail = Mail.find(:first, :conditions => {:mailbox_id => mailbox.id}, :order => "created_at DESC", :limit => 1)
      Net::POP3.start(mailbox.hostname, port, mailbox.username, mailbox.password) do |pop|              
        pop.each_mail{|m|
          str = m.pop
          email = TMail::Mail.parse(str)
          next if last_mail and email.date<last_mail.date 
          mail = Mail.create(:raw_email => str, :client => mailbox.client, :mailbox_id => mailbox.id, :subject => email.subject, 
                             :message_id => email.message_id, :date => email.date)
          email.from.each{|from|
            Receiver.create(:mail_id => mail.id, :person_id => getPerson(from).id, :receiver_type_id => 1)
          } if email.from
          
          email.to.each{|to|
            Receiver.create(:mail_id => mail.id, :person_id => getPerson(to).id, :receiver_type_id => 2)
          } if email.to
          
          email.cc.each{|cc|
            Receiver.create(:mail_id => mail.id, :person_id => getPerson(cc).id, :receiver_type_id => 3)
          } if email.cc
          
          counter+=1
        }
      end
      puts "#{counter} mails popped."
  #    pop.finish                          
      sleep 30
    rescue Exception => e
      puts e
      puts e.backtrace
      sleep 30
    end  
  }
end

