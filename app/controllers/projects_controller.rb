class ProjectsController < ApplicationController
  include Searchable

  before_action :authenticate_user!, only: [:show]

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find_by_id(params[:id])
  end

  def search
    @projects = Project.where('name ILIKE ?', "%#{search_params[:term]}%")
  end
end
