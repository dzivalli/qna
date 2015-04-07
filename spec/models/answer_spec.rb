require 'rails_helper'

RSpec.describe Answer, type: :model do

  it { is_expected.to validate_presence_of :body }
  it { is_expected.to belong_to :question}
  it { is_expected.to have_many(:attachments).dependent(:destroy)}


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

  describe '.new_with_attachment' do
    let!(:answer) { Answer.new_with_attachment }

    it 'is a new answer' do
      expect(answer.new_record?).to be_truthy
    end

    it 'has one new attachment' do
      expect(answer.attachments[0].new_record?).to be_truthy
      expect(answer.attachments.length).to eq 1
    end
  end
end
