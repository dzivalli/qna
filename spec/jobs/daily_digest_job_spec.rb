require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:users) { create_list :user, 2 }

  it 'sends email all users' do
    expect { subject.perform_now }.to change(ActionMailer::Base.deliveries, :count).by 2
  end
end
