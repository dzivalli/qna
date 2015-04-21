require 'rails_helper'

RSpec.describe Answer, type: :model do

  it { is_expected.to belong_to :question}
  it { is_expected.to have_many(:attachments).dependent(:destroy)}
  it { is_expected.to have_many(:user_votes).dependent(:destroy)}

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
    subject(:votable) { create(:answer) }

    it_behaves_like 'vote up'
  end

  describe '.vote_down!' do
    let(:user) { create(:user) }
    subject(:votable) { create(:answer) }

    it_behaves_like 'vote down'
  end

  describe '.vote_positive?' do
    let(:user) { create(:user) }
    subject(:votable) { create(:answer) }

    it_behaves_like 'positive vote'
  end

  describe '.vote_negative?' do
    let(:user) { create(:user) }
    subject(:votable) { create(:answer) }

    it_behaves_like 'negative vote'
  end
end
