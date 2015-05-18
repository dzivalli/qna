FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "My answer body #{n}"}
    user
    votes 0
    question
  end
end
