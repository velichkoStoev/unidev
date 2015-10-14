class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :project_participations
  has_many :projects, through: :project_participations

  has_attached_file :avatar,
                    styles: { medium: '300x300', thumb: '100x100' },
                    default_url: ':style/no_photo.png'
  validates_attachment_content_type :avatar, content_type: %r{/\Aimage\/.*\Z/}

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :faculty, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
