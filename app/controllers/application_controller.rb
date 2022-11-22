class ApplicationController < ActionController::Base
  include ActionView::Helpers::UrlHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :set_layout
  before_action :check_subscription, :except => [:impersonate, :stop_impersonating]
  before_action :set_user_time_zone,if: :current_user
  helper_method :my_restaurant

  def my_restaurant
    if current_user
      current_user.restaurant
    end
  end

  
  private

  def set_layout
    user_signed_in? ? "application" : (current_page?(root_path) ? "application" : "empty")
  end

  def check_subscription
    if current_user
      unless current_user.valid_subscription
        check_for_abandoment
        msg = "Please subscribe to basic plan for using ReadyText"
        path = "/pricing"

        redirect_to path,notice: msg
      end
    end
  end

  def set_user_time_zone
    Time.zone = current_user.time_zone
  end

  def check_for_abandoment
    # send abandoment email, if not sent before
    if current_user.can_send_abandoment_email
      current_user.update(can_send_abandoment_email: false)
      UserMailer.abandoment_email(current_user).deliver_later
    end
  end
end
