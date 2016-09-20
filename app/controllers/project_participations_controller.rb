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
    @project = current_user.projects.create(project_data)

    if @project.save
      flash[:notice] = 'Project successfully created!'
      redirect_to user_projects_path(current_user.id)
    else
      render 'new'
    end
  end

  def edit
    @user = User.find_by_id(params[:user_id])
    @project = Project.find_by_id(params[:id])
  end

  def update
    @project = Project.find_by_id(params[:id])
    if @project.update(project_params)
      flash[:notice] = 'Project successfully updated!'
      redirect_to user_projects_path(current_user.id)
    else
      render 'new'
    end
  end

  def destroy
    @user = User.find_by_id(params[:user_id])
    @user.projects.destroy(params[:id])

    flash[:notice] = 'Project successfully deleted!'
    redirect_to user_projects_path(params[:user_id])
  end

  def cancel
    ProjectParticipation.where(user_id: params[:user_id], project_id: params[:project_id]).delete_all
    flash[:notice] = 'You have successfully cancelled your participation!'
    redirect_to user_projects_path(params[:user_id])
  end

  private

  def project_params
    params.require(:project).permit(:name, :information, :repository_link)
  end
end
