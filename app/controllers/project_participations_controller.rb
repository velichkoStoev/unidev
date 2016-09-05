class ProjectParticipationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find_by_id(params[:user_id])
    @projects = @user.projects
  end

  def new
    @project = current_user.projects.build
  end

  def create
    project_data = project_params.merge!(creator: current_user)
    current_user.projects.create(project_data)

    flash[:notice] = 'Project successfully created!'
    redirect_to user_projects_path(current_user.id)
  end

  def edit
    @user = User.find_by_id(params[:user_id])
    @project = Project.find_by_id(params[:id])
  end

  def update
    @project = Project.find_by_id(params[:id])
    @project.update(project_params)

    flash[:notice] = 'Project successfully updated!'
    redirect_to user_projects_path(current_user.id)
  end

  def destroy
    @user = User.find_by_id(params[:user_id])
    @user.projects.destroy(params[:id])

    flash[:notice] = 'Project successfully deleted!'
    redirect_to user_projects_path(params[:user_id])
  end

  def cancel_participation
    byebug
  end

  private

  def project_params
    params.require(:project).permit(:name, :information)
  end
end
