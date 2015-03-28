require 'rails_helper'

RSpec.describe User, type: :model do
  context 'associations' do
    it { is_expected.to have_many :answers}
    it { is_expected.to have_many :questions}
  end

  describe '#owns?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'returns false if an object does not have user_id method' do
      object = ''
      expect(user.owns?(object)).to be_falsey
    end

    it 'returns true if object user_id equal to id' do
      expect(user.owns?(question)).to be_truthy
    end
  end
end
