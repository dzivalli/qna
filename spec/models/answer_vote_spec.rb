require 'rails_helper'

RSpec.describe AnswerVote, type: :model do
  it { is_expected.to belong_to :answer}
  it { is_expected.to belong_to :user}
end
