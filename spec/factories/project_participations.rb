FactoryGirl.define do
  factory :project_participation do
    association :user, factory: :user
    association :project, factory: :project
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
