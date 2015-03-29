require 'rails_helper'

RSpec.describe User, type: :model do
  context 'associations' do
    it { is_expected.to have_many :answers}
    it { is_expected.to have_many :questions}
  end

  describe '#owns?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:question_2) { create(:question) }


    it 'returns false if an object does not have user_id method' do
      object = ''
      expect(user.owns?(object)).to be_falsey
    end

    it 'returns true if object user_id equal to id' do
      expect(user.owns?(question)).to be_truthy
    end

    it 'returns false if object user_id not equal to id' do
      expect(user.owns?(question_2)).to be_falsey
    end
  end
end
