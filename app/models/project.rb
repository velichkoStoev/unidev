class Project < ActiveRecord::Base
  has_many :project_participations, dependent: :destroy
  has_many :users, through: :project_participations
  has_many :announcements, dependent: :destroy

  belongs_to :creator, foreign_key: 'creator_id', class_name: 'User'

  validates :name, presence: true
  validates :information, presence: true
  validates :creator, presence: true
  validates_format_of :repository_link, with: URI.regexp(%w(http https))

  def date_created
    created_at.localtime.strftime('%d %B %Y')
  end

  def date_updated
    updated_at.localtime.strftime('%d %B %Y')
  end

  def repository_url
    return '' unless repository_link
    repository_link_tokens = repository_link.split('/')
    "/#{repository_link_tokens[-2]}/#{repository_link_tokens[-1]}"
  end
end
