class Project < ActiveRecord::Base
  has_many :project_participations
  has_many :users, through: :project_participations

  validates :name, presence: true
  validates :information, presence: true

  def date_created
    created_at.localtime.strftime('%d %B %Y')
  end
end
