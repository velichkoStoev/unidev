class UserSkill < ActiveRecord::Base
  belongs_to :user
  belongs_to :skill

  validates :user, presence: true
  validates :skill, presence: true

  validates :user_id, uniqueness: { scope: :skill_id }
end
