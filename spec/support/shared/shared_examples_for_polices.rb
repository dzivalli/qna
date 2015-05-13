shared_examples 'authorized only for logged users' do
  permissions :create? do
    it { is_expected.to_not permit(nil, klass.new) }
    it { is_expected.to permit(user, klass.new) }
  end

  permissions :update? do
    it { is_expected.to_not permit(nil, klass.new) }
    it { is_expected.to_not permit(user, klass.new) }
    it { is_expected.to permit(user, klass.create(user: user)) }
  end

  permissions :destroy? do
    it { is_expected.to_not permit(nil, klass.new) }
    it { is_expected.to_not permit(user, klass.new) }
    it { is_expected.to permit(user, klass.create(user: user)) }
  end
end
