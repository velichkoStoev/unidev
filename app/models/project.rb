class Project < ActiveRecord::Base
  has_many :project_participations, dependent: :destroy
  has_many :users, through: :project_participations

  belongs_to :creator, foreign_key: 'creator_id', class_name: 'User'

  validates :name, presence: true
  validates :information, presence: true
  validates :creator, presence: true

  def date_created
    created_at.localtime.strftime('%d %B %Y')
  end

  def date_updated
    updated_at.localtime.strftime('%d %B %Y')
  end
end
