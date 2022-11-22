class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :check_subscription
  before_action :set_restaurant,only: :create
  before_action :configure_permitted_parameters, if: :devise_controller?

  def new
    super
  end

  def create
    @plan = get_plan(params[:plan])
    build_resource(sign_up_params)
      # skip confirmation and redirect to subscription if it comes for payment
    if verify_recaptcha(:response => params['g-recaptcha-response'])
      resource.skip_confirmation!
      resource.confirm
      resource.save
      yield resource if block_given?
      if resource.persisted?
        path = thanks_path
        cookies[:thanks_path] = path
        if resource.active_for_authentication?
          # set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          if @plan
            cookies[:plan_id] = @plan.stripe_id
          end
          # UserMailer.confirmation_email(resource).deliver_later
          respond_with resource, location: path
        else
          # set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: path
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    else
      @captcha_error = "Please confirm you are not a robot."
      render 'new'
    end
  end

  

  private
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:email,:phone,:password,:password_confirmation,:role,:time_zone,:in_trial,:can_avail_trial,:can_send_abandoment_email,:country_id,:restaurant_id])
    end
  
    def set_restaurant
      if params[:restaurant_name].present?
        restaurant = Restaurant.new(name: params[:restaurant_name],country_id: params[:user][:country_id])
        # set restaurant id in params 
        params[:user][:restaurant_id] = restaurant.id if restaurant.save
      end
    end

    def get_plan plan_id
      Plan.find_by(stripe_id: plan_id)
    end

end
