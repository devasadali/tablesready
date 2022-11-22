namespace :schedulable do
  desc "Notifiy Admin about users, whose trial is ended."
  task no_subscription_email: :environment do
    puts "Email will be sent to: #{users.size} users."
    # for now, email is non-convert email is disabled.
    # users = User.in_trial.where("trial_ends_at < ? ",Time.now)
    # users.each do |user|
    #   user.no_subscription_email
    # end
  end
end