require 'rails_helper'

RSpec.describe Question, type: :model do

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:attachments).dependent(:destroy) }

  it { is_expected.to accept_nested_attributes_for(:attachments).allow_destroy(true) }

  describe '.vote_up!' do
    let!(:question) { create(:question) }

    it 'increases votes by 1' do
      expect{ question.vote_up! }.to change(question, :votes).by(1)
    end
  end

  describe '.vote_down!' do
    let!(:question) { create(:question) }

    it 'decreases votes by 1' do
      expect{ question.vote_down! }.to change(question, :votes).by(-1)
    end
  end
end
