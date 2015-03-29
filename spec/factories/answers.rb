FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "My answer body #{n}"}
    user
  end
end
