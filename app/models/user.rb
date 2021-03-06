class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :project_participations
  has_many :projects, through: :project_participations
  has_many :created_projects, foreign_key: :creator_id, class_name: 'Project'
  has_many :user_skills
  has_many :skills, through: :user_skills
  has_many :announcements, dependent: :destroy
  has_many :sent_messages, foreign_key: :sender_id, class_name: 'Message'
  has_many :received_messages, foreign_key: :receiver_id, class_name: 'Message'

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
  validates :email, presence: true,
                    format: {
                      with: Devise.email_regexp,
                      message: 'The e-mail domain must be @unidev.com'
                    }

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
