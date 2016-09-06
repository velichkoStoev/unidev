class Announcement < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates :text, presence: true, length: { minimum: 20 }
  validates :user, presence: true
  validates :project, presence: true
end
