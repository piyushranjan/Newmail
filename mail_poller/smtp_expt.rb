require "rubygems"
require 'net/smtp'
require 'uuid'
uuid = UUID.new
msgstr = <<END_OF_MESSAGE
    From: Piyush Ranjan <piyush.pr@gmail.com>
    To: Piyush Ranjan <piyush.pr@gmail.com>
    Subject: test message
    Date: Sat, 26 Sep 2009 14:26:43 +0900
    Message-Id: <#{uuid.generate}@mail.cleartrip.com>

    This is a test message.
END_OF_MESSAGE
puts msgstr
smtp = Net::SMTP.start('mail.cleartrip.com', 25, 'cleartrip.com', 'piyush_ranjan', '', :login)
p smtp
smtp.send_message msgstr.to_s,'piyush.ranjan@cleartrip.com','piyush.pr@gmail.com'
smtp.finish
p smtp


