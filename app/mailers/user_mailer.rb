class UserMailer < ApplicationMailer
  default from: ENV['HELLO_EMAIL']
  # layout 'mailer'

  def test_email(sender,recipent)
    mail(from: sender,to: recipent, subject: 'Test Email')
  end

  def subscription_auto_email(user,subscription)
    @user = user
    @subscription = subscription
    sub = subscription.trial? ? "trial7352" : (subscription.walkin? ? "paid9922" : "marketing7222")
    mail(to: ENV['HELLO_EMAIL'],subject: sub)
  end

  def subscription_cancel_email(user,plan)
    @user = user
    @plan = plan
    sub = "cancel911"
    mail(to: ENV['HELLO_EMAIL'],subject: sub)
  end

  def non_subscriber_email(user)
    @user = user
    sub = "nonconvert7333"
    mail(to: ENV['HELLO_EMAIL'],subject: sub)
  end

  def abandoment_email(user)
    @user = user
    sub = "abandon123"
    mail(to: ENV['HELLO_EMAIL'],subject: sub)
  end

  def support_email(name,email,body)
    @name = name
    @email = email
    @body = body
    mail(to: ENV['HELLO_EMAIL'],subject: "Support")
  end

  def trial_extend_request(user)
    @user = user
    mail(to: ENV['HELLO_EMAIL'],subject: "Trial Extend Request")
  end

  def confirmation_email(user)
    @user = user
    mail(to: @user.email,subject: "Account Confirmation")
  end

  def approve_message_template(user, message_template, is_new = false)
    @user = user
    @message_template = message_template
    @is_new = is_new
    mail(to: ENV['HELLO_EMAIL'],subject: "Approve Message Template")
    # mail(to: 'nodari.sikharulidze.1@gmail.com',subject: "Approve Message Template")
  end

  def approve_message_template_pending(user)
    @user = user
    mail(to: @user.email,subject: "Your Message Template is pending approval")
    # mail(to: 'nodari.sikharulidze.1@gmail.com',subject: "Approve Message Template")
  end

  def approved_message_template(user, message_template, is_new = false)
    @user = user
    @message_template = message_template
    mail(to: @user.email,subject: "Your Message Template is approved")
    # mail(to: 'nodari.sikharulidze.1@gmail.com',subject: "Your Message Template is approved")
  end
end