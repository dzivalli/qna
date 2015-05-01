require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :commentable }

  it { is_expected.to validate_presence_of :body}

  describe '#find_parent' do
    let(:question) { create(:question) }

    it 'returns parent object by given params' do
      expect(Comment.find_parent(question_id: question)).to eq question
    end

    it 'returns false if no key in params' do
      expect(Comment.find_parent({})).to be_falsey
    end

    it 'returns false if no such class' do
      expect(Comment.find_parent(noclass_id: 1)).to be_falsey
    end
  end
end
