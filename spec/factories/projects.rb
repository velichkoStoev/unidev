FactoryGirl.define do
  factory :project do
    name 'Project'
    information 'Information'
    repository_link 'https://github.com/test/repository'
    association :creator, factory: :user
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
