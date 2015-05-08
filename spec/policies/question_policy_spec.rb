require 'rails_helper'

describe QuestionPolicy do
  let(:user) { create :user }
  let(:klass) { described_class.name.split('Policy').first.safe_constantize }
  subject { described_class }

  it_behaves_like 'authorized only for logged users'
end
