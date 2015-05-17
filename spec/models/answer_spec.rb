require 'rails_helper'

RSpec.describe Answer, type: :model do

  it { is_expected.to belong_to :question }
  it { is_expected.to validate_presence_of :body }

  it_behaves_like 'attachable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'
  it_behaves_like 'reputable'

  describe '#best!' do
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 3, question: question, best: true) }
    let(:best_answer) { create(:answer, question: question, best: false) }

    before { best_answer.best! }

    it 'sets best to nil for all answers belong to the same question' do
      answers.each do |answer|
        answer.reload
        expect(answer.best).to  be_falsey
      end
    end

    it 'updates best to true for that question' do
      expect(best_answer.best).to be_truthy
    end
  end

  describe 'notification' do
    let!(:user) { create :user }
    let!(:question) { create :question, user: user}

    let!(:others) { create_list :user, 2 }
    let!(:notification1) { create :notification, user: others[0], question: question }
    let!(:notification2) { create :notification, user: others[1], question: question }

    it 'sends email to owner and subscribed users' do
      expect(UserMailer).to receive(:answer_notification).with(kind_of(Answer), user.email).and_call_original

      others.each do |other|
        expect(UserMailer).to receive(:answer_notification).with(kind_of(Answer), other.email).and_call_original
      end

      create :answer, question: question
    end
  end
end
