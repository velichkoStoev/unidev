class SkillsController < ApplicationController
  def index
    @skills = User.find(params[:user_id]).skills
  end
end
