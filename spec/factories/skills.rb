FactoryGirl.define do
  factory :skill do
    name 'Skill'
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
