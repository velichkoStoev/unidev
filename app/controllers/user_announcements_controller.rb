class UserAnnouncementsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find_by_id(params[:user_id])
    @announcements = @user.announcements
  end

  def new
    @user = User.find_by_id(params[:user_id])
    @projects = @user.projects
    @announcement = Announcement.new
  end

  def create
    current_user.announcements.create!(announcement_params)

    flash[:notice] = 'Announcement successfully created!'
    redirect_to user_announcements_path(current_user.id)
  end

  def edit
    @user = User.find_by_id(params[:user_id])
    @announcement = Announcement.find_by_id(params[:id])
    @projects = @user.projects
  end

  def update
    @announcement = Announcement.find_by_id(params[:id])
    @announcement.update(announcement_params)

    flash[:notice] = 'Announcement successfully updated!'
    redirect_to user_announcements_path(current_user.id)
  end

  def destroy
    @user = User.find_by_id(params[:user_id])
    @user.announcements.destroy(params[:id])

    flash[:notice] = 'Announcement successfully deleted!'
    redirect_to user_announcements_path(current_user.id)
  end

  private

  def announcement_params
    params.require(:announcement).permit(:text, :project_id)
  end
end
