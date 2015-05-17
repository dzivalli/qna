require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:users) { create_list :user, 2 }

  it 'sends email all users' do
    users.each do |user|
      expect(UserMailer).to receive(:digest).and_call_original
    end

    DailyDigestJob.perform_now
  end
end
