#!/usr/bin/ruby
require "rubygems"
require "tmail"
require 'net/pop'
require 'net/imap'
require "active_record"
require "yaml"
require "ftools"


RAILS_ROOT = File.join(File.dirname(__FILE__), "../webapp")
require File.join(RAILS_ROOT, "config", "constants")
require File.join(RAILS_ROOT, "lib", "add_dm_to_ar")

ActiveRecord::Base.establish_connection(YAML.load(File.read("#{RAILS_ROOT}/config/database.yml"))["development"])
Dir.glob(File.join(RAILS_ROOT, "app/models/*.rb")).each{|f| require f}

while true
  Mailbox.all(:order => "created_at DESC").each{|mailbox|
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
          next if last_mail and email and email.date and email.date<last_mail.date 
          mail = Mail.create(:raw_email => str, :client => mailbox.client, :mailbox_id => mailbox.id, :subject => email.subject, 
                             :message_id => email.message_id, :date => email.date)
          email.from_addrs.each{|from|
            if from.class==TMail::AddressGroup
              from.each_address{|address|
                Receiver.create(:mail_id => mail.id, :person_id => Person.find_or_create(address, mailbox.client).id, :receiver_type_id => 1)
              }
            else
              Receiver.create(:mail_id => mail.id, :person_id => Person.find_or_create(from, mailbox.client).id, :receiver_type_id => 1)
            end
          } if email.from_addrs
          
          email.to_addrs.each{|to|
            if to.class==TMail::AddressGroup
              to.each_address{|address|
                Receiver.create(:mail_id => mail.id, :person_id => Person.find_or_create(address, mailbox.client).id, :receiver_type_id => 1)
              }
            else
              Receiver.create(:mail_id => mail.id, :person_id => Person.find_or_create(to, mailbox.client).id, :receiver_type_id => 2)
            end
          } if email.to_addrs
          
          email.cc.each{|cc|
            if cc.class==TMail::AddressGroup
              cc.each_address{|address|
                Receiver.create(:mail_id => mail.id, :person_id => Person.find_or_create(address, mailbox.client).id, :receiver_type_id => 3)
              }
            else
              Receiver.create(:mail_id => mail.id, :person_id => Person.find_or_create(cc, mailbox.client).id, :receiver_type_id => 3)
            end            
          } if email.cc
          m.delete
          counter+=1
        }
      end
      puts "#{counter} mails popped."
      sleep 30
    rescue Exception => e
      puts e
      puts e.backtrace
    end  
  }
end

