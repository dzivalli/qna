FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@mail.ru" }
    password 'asdfasdf'
    password_confirmation 'asdfasdf'
  end
end
