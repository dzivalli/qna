require 'rails_helper'

RSpec.describe Question, type: :model do

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:attachments).dependent(:destroy) }
  it { is_expected.to have_many(:user_votes).dependent(:destroy) }

  it { is_expected.to accept_nested_attributes_for(:attachments).allow_destroy(true) }

  describe '.vote_up!' do
    let(:user) { create(:user) }
    subject(:votable) { create(:question) }

    it_behaves_like 'vote up'
  end

  describe '.vote_down!' do
    let(:user) { create(:user) }
    subject(:votable) { create(:question) }

    it_behaves_like 'vote down'
  end

  describe '.negative_vote?' do
    let(:user) { create(:user) }
    subject(:votable) { create(:question) }

    it_behaves_like 'negative vote'
  end

  describe '.positive_vote?' do
    let(:user) { create(:user) }
    subject(:votable) { create(:question) }

    it_behaves_like 'positive vote'
  end
end
