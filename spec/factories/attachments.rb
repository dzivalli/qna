FactoryGirl.define do
  factory :attachment do
    # sequence(:file) { |n| "My file #{n}" }
    # attachable_id 1
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'spec_helper.rb')) }
  end

end
