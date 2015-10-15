class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :project_participations
  has_many :projects, through: :project_participations
  has_many :user_skills
  has_many :skills, through: :user_skills

  attr_accessor :delete_avatar

  has_attached_file :avatar,
                    styles: { medium: '300x300', thumb: '200x200' },
                    default_url: ':style/no_photo.png'

  validates_attachment :avatar, content_type: {
    content_type: ['image/jpeg', 'image/png']
  }

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :faculty, presence: true

  before_validation { avatar.clear if delete_avatar == '1' }

  def full_name
    "#{first_name} #{last_name}"
  end

  def birthday
    birth_date.strftime('%d %B %Y')
  end

  def date_created
    created_at.strftime('%d %B %Y')
  end

  def date_last_updated
    updated_at.strftime('%d %B %Y')
  end
end
