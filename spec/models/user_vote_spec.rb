require 'rails_helper'

RSpec.describe UserVote, type: :model do
  it { is_expected.to belong_to :votable}
  it { is_expected.to belong_to :user}
end
