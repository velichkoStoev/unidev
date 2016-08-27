class SkillsController < ApplicationController
  def create
    @skill = Skill.where(name: skill_params[:name]).first
    @skill = Skill.create!(name: skill_params[:name]) unless @skill
    UserSkill.create!(user: current_user, skill: @skill)

    respond_to { |format| format.js }
  rescue ActiveRecord::RecordInvalid
    respond_to do |format|
      format.js { render 'create_error' }
    end
  end

  def destroy
    @skill_id = params[:id]
    current_user.skills.where(id: @skill_id).destroy_all
    respond_to { |format| format.js }
  end

  private

  def skill_params
    skill_params = params.require(:skill).permit(:name)
    skill_params[:name].strip!
    skill_params
  end
end
