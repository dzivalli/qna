FactoryGirl.define do
  factory :answer do
    question nil
    sequence(:body) { |n| "My answer body #{n}"}
  end
end
