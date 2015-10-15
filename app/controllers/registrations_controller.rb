class RegistrationsController < Devise::RegistrationsController
  private

  # Redirect to user profile after editing the profile
  def after_update_path_for(resource)
    user_path(resource)
  end

  # We override the default Devise methods 'sign_up_params'
  # and 'account_update_params' in order to add our custom fields

  def sign_up_params
    params.require(:user).permit(:first_name,
                                 :last_name, :faculty,
                                 :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:avatar, :first_name, :last_name, :faculty,
                                 :email, :password, :password_confirmation,
                                 :current_password, :delete_avatar, :about_me)
  end
end
