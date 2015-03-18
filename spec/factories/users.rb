FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@mail.ru"
  end
  factory :user do
    email
    password 'asdfasdf'
    password_confirmation 'asdfasdf'
  end

end
