require 'rails_helper'

describe VotableModelPolicy do
  let(:user) { create :user }
  subject { described_class }

  permissions :up? do
    it { is_expected.to_not permit(nil, Question.new) }
    it { is_expected.to permit(user, Question.new) }
    it { is_expected.to_not permit(user, Question.create(user: user)) }
  end

  permissions :down? do
    it { is_expected.to_not permit(nil, Question.new) }
    it { is_expected.to permit(user, Question.new) }
    it { is_expected.to_not permit(user, Question.create(user: user)) }
  end
end
