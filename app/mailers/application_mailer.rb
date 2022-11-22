class ApplicationMailer < ActionMailer::Base
  default from: ENV['HELLO_EMAIL']
  layout 'mailer'
end
