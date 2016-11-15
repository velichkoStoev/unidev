class Skill < ActiveRecord::Base
  has_many :user_skills
  has_many :users, through: :user_skills

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
