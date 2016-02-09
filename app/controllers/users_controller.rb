class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @projects = Project.select('name, projects.created_at, role, is_creator')
                .joins(:project_participations).where('user_id = ?', @user.id)
  end

  def edit
    @skills = current_user.skills
    @new_skill = Skill.new
  end
end
