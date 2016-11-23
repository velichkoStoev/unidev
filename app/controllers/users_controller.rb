class UsersController < ApplicationController
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
    if search_params[:user_email].nil? || search_params[:user_email].empty?
      flash[:warning] = 'Please, input something in the search field!'
      redirect_to action: :index
    end

    @users = User.where('email ILIKE ?', "%#{search_params[:user_email]}%")
  end

  private

  def search_params
    params.require(:search).permit(:user_email)
  end
end
