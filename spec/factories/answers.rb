FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "My answer body #{n}"}
  end
end
