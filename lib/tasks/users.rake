namespace :users do
  desc "Set existing users as paid or marketing if any subscription exists"
  task set_user_subscription_status: :environment do
    puts "Set user subscription status."
    users = User.all
    users.each do |user|
      user.paid! if user.subscriptions.walkin.any?
      user.marketing! if user.subscriptions.marketing.any?
    end
  end
end