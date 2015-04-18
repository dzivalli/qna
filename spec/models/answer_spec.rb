require 'rails_helper'

RSpec.describe Answer, type: :model do

  it { is_expected.to belong_to :question}
  it { is_expected.to have_many(:attachments).dependent(:destroy)}
  it { is_expected.to have_many(:answer_votes).dependent(:destroy)}

  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for(:attachments).allow_destroy(true) }

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

  describe '.vote_up!' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }

    context 'when there are no previous votes' do
      before { answer.vote_up!(user) }

      it 'increases votes by 1' do
        expect(answer.votes).to eq 1
      end

      it 'sets positive attr of question_vote to true' do
        expect(answer.answer_votes.find_by(user: user).positive).to be_truthy
      end
    end

    context 'when previous vote was negative' do
      before do
        answer.vote_down!(user)

        answer.vote_up!(user)
      end

      it 'deletes vote' do
        expect(answer.answer_votes.find_by(user: user)).to be_falsey
      end

      it 'increase votes count by 1' do
        expect(answer.votes).to eq 0
      end
    end
  end

  describe '.vote_down!' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }

    context 'when there are no previous votes' do
      before { answer.vote_down!(user) }

      it 'decreases votes by 1' do
        expect(answer.votes).to eq -1
      end

      it 'sets positive attr of question_vote to false' do
        expect(answer.answer_votes.find_by(user: user).positive).to be_falsey
      end
    end

    context 'when previous vote was positive' do
      before do
        answer.vote_up!(user)

        answer.vote_down!(user)
      end

      it 'deletes vote' do
        expect(answer.answer_votes.find_by(user: user)).to be_falsey
      end

      it 'increase votes count by -1' do
        expect(answer.votes).to eq 0
      end
    end

  end

  describe '.vote_of' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }

    it 'returns 1 if vote positive' do
      create(:answer_vote, user: user, answer: answer, positive: true)

      expect(answer.vote_of(user)).to eq 1
    end

    it 'returns -1 if vote negative' do
      create(:answer_vote, user: user, answer: answer, positive: false)

      expect(answer.vote_of(user)).to eq -1
    end

    it 'returns false if there are no votes' do
      expect(answer.vote_of(user)).to be_falsey
    end
  end
end
