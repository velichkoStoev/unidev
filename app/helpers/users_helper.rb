module UsersHelper
  def user_same_as_current?
    @user.id == current_user.id
  end
end
