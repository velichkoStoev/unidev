class RegistrationsController < Devise::RegistrationsController
  private

  # We override the default Devise methods 'sign_up_params'
  # and 'account_update_params' in order to add our custom fields

  def sign_up_params
    params.require(:user).permit(:first_name,
                                 :last_name, :faculty,
                                 :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :faculty,
                                 :email, :password, :password_confirmation,
                                 :current_password)
  end
end
