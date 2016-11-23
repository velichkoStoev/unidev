FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "test_user#{n}@unidev.com" }
    first_name 'Test'
    last_name 'Testing'
    faculty 'FAC'
    password 'password'
    password_confirmation 'password'
    about_me 'About me'
    birth_date { Time.zone.now }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
