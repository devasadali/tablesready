class UsersController < ApplicationController
  before_action :authenticate_user!, :except => [:impersonate, :stop_impersonating]
  before_action :admin_only, :except => [:show, :trial_extend_request, :impersonate, :stop_impersonating]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    unless current_user.admin?
      unless @user == current_user
        redirect_to root_path, :alert => "Access denied."
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  def trial_extend_request
    user = User.find(params[:id])
    UserMailer.trial_extend_request(user).deliver_later
    respond_to do |format|
      format.js {render layout: false}
      format.html
    end
  end

  def impersonate
    user = User.find(params[:id])
    sign_in(user, scope: :user)
    session[:impersonate_user] = user.id
    redirect_to root_path
  end

  def stop_impersonating
    session[:impersonate_user] = nil
    sign_out current_user
    redirect_to admin_root_path
  end

  private

  def admin_only
    unless current_user.admin?
      redirect_to root_path, :alert => "Access denied."
    end
  end

  def secure_params
    params.require(:user).permit(:role)
  end

end
