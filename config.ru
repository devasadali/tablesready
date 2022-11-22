# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

run Rails.application

if Rails.env.production?
  DelayedJobWeb.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.variable_size_secure_compare('dustin', username) &&
      ActiveSupport::SecurityUtils.variable_size_secure_compare('321321321', password)
  end
end