class PagesController < ApplicationController
  before_action :authenticate_user!, except: :home

  def home
  end

  def dashboard
    @projects = current_user.projects
    @announcements = current_user.announcements
    @unread_messages_count = Message.where(receiver_id: current_user.id, is_read: false).count
  end
end
