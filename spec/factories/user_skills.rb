FactoryGirl.define do
  factory :user_skill do
    association :user, factory: :user
    association :skill, factory: :skill
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
