require 'rails_helper'

RSpec.describe Answer, type: :model do

  context 'validations' do
    it { is_expected.to validate_presence_of :body }
  end

  context 'associations' do
    it { is_expected.to belong_to :question}
    it { is_expected.to have_one :question_as_best}
  end
  
end
