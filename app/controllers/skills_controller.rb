class SkillsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:user_id].to_i != current_user.id
      flash[:warning] = 'You can edit only your profile!'
      redirect_to :dashboard
    end

    @skills = current_user.skills
  end

  def create
    @skill = Skill.find_or_create_by(name: skill_params[:name])
    current_user.skills << @skill

    respond_to { |format| format.js }
  rescue ActiveRecord::RecordInvalid => exception
    handle_validation_error(exception)

    respond_to do |format|
      format.js { render 'new' }
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

  def handle_validation_error(exception)
    validation_error = exception.message.split(': ').last
    @skill.errors.add(:name, 'You already have this skill') if validation_error == 'User has already been taken'
  end
end
