class AnnouncementsController < ApplicationController
  before_action :authenticate_user!

  def index
    @announcements = Announcement.all
  end
end
