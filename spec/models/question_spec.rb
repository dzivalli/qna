require 'rails_helper'

RSpec.describe Question, type: :model do

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:attachments).dependent(:destroy) }
  it { is_expected.to have_many(:question_votes).dependent(:destroy) }

  it { is_expected.to accept_nested_attributes_for(:attachments).allow_destroy(true) }

  describe '.vote_up!' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context 'when there are no previous votes' do
      before { question.vote_up!(user) }

      it 'increases votes by 1' do
        expect(question.votes).to eq 1
      end

      it 'sets positive attr of question_vote to true' do
        expect(question.question_votes.find_by(user: user).positive).to be_truthy
      end
    end

    context 'when previous vote was negative' do
      before do
        question.vote_down!(user)

        question.vote_up!(user)
      end

      it 'deletes vote' do
        expect(question.question_votes.find_by(user: user)).to be_falsey
      end

      it 'increase votes count by 1' do
        expect(question.votes).to eq 0
      end
    end
  end

  describe '.vote_down!' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context 'when there are no previous votes' do
      before { question.vote_down!(user) }

      it 'decreases votes by 1' do
        expect(question.votes).to eq -1
      end

      it 'sets positive attr of question_vote to false' do
        expect(question.question_votes.find_by(user: user).positive).to be_falsey
      end
    end

    context 'when previous vote was positive' do
      before do
        question.vote_up!(user)

        question.vote_down!(user)
      end

      it 'deletes vote' do
        expect(question.question_votes.find_by(user: user)).to be_falsey
      end

      it 'increase votes count by -1' do
        expect(question.votes).to eq 0
      end
    end

  end

  describe '.vote_of' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    it 'returns 1 if vote positive' do
      create(:question_vote, user: user, question: question, positive: true)

      expect(question.vote_of(user)).to eq 1
    end

    it 'returns -1 if vote negative' do
      create(:question_vote, user: user, question: question, positive: false)

      expect(question.vote_of(user)).to eq -1
    end

    it 'returns false if there are no votes' do
      expect(question.vote_of(user)).to be_falsey
    end
  end
end
