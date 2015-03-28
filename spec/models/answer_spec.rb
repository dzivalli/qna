require 'rails_helper'

RSpec.describe Answer, type: :model do

  context 'validations' do
    it { is_expected.to validate_presence_of :body }
  end

  context 'associations' do
    it { is_expected.to belong_to :question}
  end


  describe '#best!' do
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 3, question: question, best: true) }
    let(:best_answer) { create(:answer, question: question, best: false) }

    before { best_answer.best! }

    it 'sets best to nil for all answers belongs to the same question' do
      answers.each do |answer|
        answer.reload
        expect(answer.best).to  be_falsey
      end
    end

    it 'updates best to true for that question' do
      expect(best_answer.best).to be_truthy
    end

  end
end
