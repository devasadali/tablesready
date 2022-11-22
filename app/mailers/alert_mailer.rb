class AlertMailer < ApplicationMailer
  default from: ENV['HELLO_EMAIL']
  # layout 'mailer'

  def disk_usage_alert(disk_usage)
  	@disk_usage = disk_usage
  	to_email = ENV['HELLO_EMAIL'].to_s
  	mail(to: to_email, bcc: 'srladuani@gmail.com',subject: "Alert! ReadyText server reached #{disk_usage}%")
  end
end