class SkillsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @skills = @user.skills
    @new_skill = Skill.new
  end

  def create
    @skill = Skill.find_by_name(skill_params[:name])

    # TODO: Implement error handling here!

    if @skill
      create_user_skill
    else
      @skill = current_user.skills.build(skill_params)
      respond_to do |format|
        if @skill.save
          create_user_skill
          format.js
        else
          format.js { render 'create_error' }
        end
      end
    end
  end

  private

  def create_user_skill
    UserSkill.create(skill: @skill, user: current_user)
  end

  def skill_params
    params.require(:skill).permit(:name)
  end
end
