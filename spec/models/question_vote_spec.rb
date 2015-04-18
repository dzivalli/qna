require 'rails_helper'

RSpec.describe QuestionVote, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :question }
end
