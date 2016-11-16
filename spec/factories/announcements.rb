FactoryGirl.define do
  factory :announcement do
    text 'Text Text Text Text Text Text'
    association :user, factory: :user
    association :project, factory: :project
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
