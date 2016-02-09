class SkillsController < ApplicationController
  def create
    @skill = current_user.skills.create!(skill_params)
    respond_to { |format| format.js }
  rescue ActiveRecord::RecordInvalid
    respond_to do |format|
      format.js { render 'create_error' }
    end
  end

  private

  def skill_params
    params.require(:skill).permit(:name)
  end
end
