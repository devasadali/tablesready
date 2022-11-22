class Users::PasswordsController < Devise::PasswordsController
  skip_before_action :check_subscription
end