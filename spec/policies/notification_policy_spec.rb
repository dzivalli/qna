require 'rails_helper'

describe NotificationPolicy do

  let(:user) { User.new }

  subject { described_class }

  permissions :create? do
    it { is_expected.to_not permit(nil, Notification.new) }
    it { is_expected.to permit(User.new, Notification.new)}
  end

  permissions :destroy? do
    let(:user) { create :user }

    it { is_expected.to_not permit(nil, Notification.new) }
    it { is_expected.to permit(user, Notification.create(user: user)) }
  end
end
