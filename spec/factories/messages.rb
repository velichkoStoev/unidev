FactoryGirl.define do
  factory :message do
    title 'Title'
    body 'Body'
    association :sender, factory: :user
    association :receiver, factory: :user
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
