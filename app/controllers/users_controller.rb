class UsersController < ApplicationController
  include Searchable

  before_action :authenticate_user!, except: [:index, :search]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @projects = @user.projects
    @announcements = @user.announcements
  end

  def search
    @users = User.where('email ILIKE ?', "%#{search_params[:term]}%")
  end
end
