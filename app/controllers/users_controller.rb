class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @projects = @user.projects
    @announcements = @user.announcements
  end

  def edit
    if params[:id].to_i != current_user.id
      flash[:warning] = 'You can edit only your profile!'
      redirect_to :dashboard
    end

    @skills = current_user.skills
    @new_skill = Skill.new
  end
end
