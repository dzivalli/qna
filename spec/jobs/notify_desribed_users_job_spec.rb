require 'rails_helper'

RSpec.describe NotifySubscribedUsersJob, type: :job do
  let!(:question) { create :question }
  let!(:answer) { create :answer, question: question }
  let!(:users) { create_list :user, 2 }
  let!(:notification1) { create :notification, user: users[0], question: question }
  let!(:notification2) { create :notification, user: users[1], question: question }

  it 'sends email to subscribed users' do
    users.each do |user|
      expect(UserMailer).to receive(:answer_notification).with(answer, user.email).and_call_original
    end

    NotifySubscribedUsersJob.perform_now(answer)
  end
end
