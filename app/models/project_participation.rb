class ProjectParticipation < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates :project, presence: true
  validates :user, presence: true
  validates :is_creator, presence: true
end
