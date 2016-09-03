class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @projects = Project.select('name, projects.created_at, role, is_creator')
                .joins(:project_participations).where('user_id = ?', @user.id)
  end

  def edit
    if params[:id] != current_user.id
      flash[:warning] = 'You can edit only your profile!'
      redirect_to :dashboard
    end

    @skills = current_user.skills
    @new_skill = Skill.new
  end
end
