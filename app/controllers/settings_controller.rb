class SettingsController < ApplicationController
  
  def profile
    @user = current_user
    @restaurant = @user.restaurant
  end

  def update_profile
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to profile_settings_path,notice: "Profile updated successfully."
  end


  private
    def user_params
      params.require(:user).permit(:name,:phone,:no_show_threshold,:auto_noshowable,:remove_records,:time_zone,restaurant_attributes: [:id,:name])
    end
end
