class ProjectsController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find_by_id(params[:id])
  end

  def search
    if search_params[:project_name].nil? || search_params[:project_name].empty?
      flash[:warning] = 'Please, input something in the search field!'
      redirect_to action: :index
    end

    @projects = Project.where('name ILIKE ?', "%#{search_params[:project_name]}%")
  end

  private

  def search_params
    params.require(:search).permit(:project_name)
  end
end
