class PagesController < ApplicationController
  layout 'application'
  skip_before_action :check_subscription
  def pricing
    @walkin_plans = Plan.walkin
    @marketing_plans = Plan.marketing
  end

  def support
    if request.post?
      UserMailer.support_email(params[:name],params[:email],params[:body]).deliver_later
    end
    respond_to do |format|
      format.js {render layout: false}
      format.html
    end
  end

  def thanks
    redirect_to root_path unless thankable?
    if @plan
      gon.redirect_to_path = new_subscription_path(plan_id: @plan.stripe_id)
    end
  end

  def search_results
  end

  def lockscreen
    render :layout => "empty"
  end

  def invoice
  end

  def invoice_print
    render :layout => "empty"
  end

  def login
    render :layout => "empty"
  end

  def login_2
    render :layout => "empty"
  end

  def register
    render :layout => "empty"
  end

  def internal_server_error
    render :layout => "empty"
  end

  def empty_page
  end

  def not_found_error
    render :layout => "empty"
  end


  private
    def thankable?
      result = false
      @plan = Plan.find_by(stripe_id: cookies[:plan_id])
      if cookies[:thanks_path].present?
        cookies.delete :thanks_path
        cookies.delete :plan_id
        result = true
      end
      result
    end

end
