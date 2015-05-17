require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  describe '.answer_notification' do
    let(:question) { create :question, user: user }
    let(:user) { create :user }
    let(:answer) { create :answer, question: question }

    it 'sends email' do
      expect { UserMailer.answer_notification(answer).deliver_now }.to change(ActionMailer::Base.deliveries, :count).by 1
    end

    it 'contains answer body' do
      email = UserMailer.answer_notification(answer)

      expect(email).to have_content answer.body
    end
  end
end
