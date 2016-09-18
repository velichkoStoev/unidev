module ApplicationHelper
  def user_same_as_current?
    @user.id == current_user.id
  end

  def user_different_than_current?
    @user.id != current_user.id
  end

  def user_project_creator?
    @project.creator.id == @user.id
  end

  def current_user_project_creator?
    @project.creator.id == current_user.id
  end
end
