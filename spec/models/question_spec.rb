require 'rails_helper'

RSpec.describe Question, type: :model do

  context 'validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :body }
  end

  context 'associations' do
    it { is_expected.to have_many(:answers).dependent(:destroy) }
    it { is_expected.to belong_to :best_answer }
  end

end
