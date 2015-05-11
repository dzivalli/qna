FactoryGirl.define do
  factory :oauth_access_token, class: Doorkeeper::AccessToken do
    application { create :oauth_application }
    resource_owner_id { create(:user).id }
  end
end