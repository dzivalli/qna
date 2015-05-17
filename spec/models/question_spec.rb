require 'rails_helper'

RSpec.describe Question, type: :model do

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:notifications).dependent(:destroy) }

  it_behaves_like 'attachable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'
  it_behaves_like 'reputable'

  describe '.notification_of' do
    let(:user) { create :user }
    let(:question) { create :question }
    let(:notification) { create :notification, question: question, user: user }

    it 'returns notification if user is subscribed on question' do
      notification
      expect(question.notification_of(user)).to eq notification
    end

    it 'returns false if user is not subscribed on question' do
      expect(question.notification_of(user)).to be_falsey
    end
  end
end
