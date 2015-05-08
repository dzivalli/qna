require 'rails_helper'

describe AnswerPolicy do
  let(:user) { create :user }
  let(:klass) { described_class.name.split('Policy').first.safe_constantize }
  subject { described_class }

  it_behaves_like 'authorized only for logged users'

  permissions :choice? do
    let!(:question_1) { create :question, user: user }
    let!(:question_2) { create :question }

    it { is_expected.to_not permit(nil, Answer.new) }
    it { is_expected.to permit(user, Answer.new(question: question_1)) }
    it { is_expected.to_not permit(user, Answer.new(question: question_2, user: user)) }
  end
end
