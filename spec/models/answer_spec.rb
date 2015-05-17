require 'rails_helper'

RSpec.describe Answer, type: :model do

  it { is_expected.to belong_to :question }
  it { is_expected.to validate_presence_of :body }

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

  it_behaves_like 'attachable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'
  it_behaves_like 'reputable'

  it 'sends email notification' do
    expect(UserMailer).to receive(:answer_notification).and_call_original

    create :answer
  end
end
