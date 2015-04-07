FactoryGirl.define do
  factory :attachment do
    sequence(:file) { |n| "My file #{n}" }
    attachable_id 1
    attachable_type "MyString"
  end

end
