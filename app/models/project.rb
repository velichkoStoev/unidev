class Project < ActiveRecord::Base
  has_many :project_participations
  has_many :users, through: :project_participations
end
