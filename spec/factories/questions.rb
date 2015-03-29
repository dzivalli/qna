FactoryGirl.define do
  factory :question do
    user nil
    sequence(:title) { |n| "My question title #{n}" }
    sequence(:body) { |n| "My question body #{n}" }
  end
end
