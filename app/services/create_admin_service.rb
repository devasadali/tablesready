class CreateAdminService
  def call
    AdminUser.create!(
        email: Rails.application.secrets.admin_email,
        password: Rails.application.secrets.admin_password,
        password_confirmation: Rails.application.secrets.admin_password
      )
  end
end
