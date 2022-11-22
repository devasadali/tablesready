class Users::SessionsController < Devise::SessionsController
  skip_before_action :check_subscription
end