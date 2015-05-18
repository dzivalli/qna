require 'rails_helper'

RSpec.describe User, type: :model do
  context 'associations' do
    it { is_expected.to have_many :answers}
    it { is_expected.to have_many :questions}
    it { is_expected.to have_many(:notifications).dependent(:destroy) }
  end

  describe '#owns?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:question_2) { create(:question) }


    it 'returns false if an object does not have user_id method' do
      object = ''
      expect(user.owns?(object)).to be_falsey
    end

    it 'returns true if object user_id equal to id' do
      expect(user.owns?(question)).to be_truthy
    end

    it 'returns false if object user_id not equal to id' do
      expect(user.owns?(question_2)).to be_falsey
    end
  end

  describe '#from_omniauth' do
    let(:auth) { OmniAuth::AuthHash.new("provider" => "facebook",
                                        "uid" => "1020665435374579",
                                        "info" => {"email" => "test@test.com"}) }

    context 'when user is new' do
      it 'adds new user' do
        expect{ User.from_omniauth(auth) }.to change(User, :count).by 1
      end

      it 'returns correct user' do
        expect(User.from_omniauth(auth).email).to eq auth[:info][:email]
      end

      it 'saves correct auth params from hash' do
        authentication = User.from_omniauth(auth).authentications.first

        expect(authentication.provider).to eq auth[:provider]
        expect(authentication.uid).to eq auth[:uid]
      end
    end

    context 'when user has no authentication' do
      let!(:user) { create(:user, email: auth[:info][:email]) }

      it 'returns correct user' do
        expect(User.from_omniauth(auth)).to eq user
      end

      it 'creates new authentications' do
        expect{ User.from_omniauth(auth) }.to change(user.authentications, :count).by 1
      end

      it 'saves correct auth params from hash' do
        authentication = User.from_omniauth(auth).authentications.first

        expect(authentication.provider).to eq auth[:provider]
        expect(authentication.uid).to eq auth[:uid]
      end
    end

    context 'when user has authentication' do
      let!(:user) { create(:user, email: auth[:info][:email]) }
      let!(:authentication) { create(:authentication, user: user, provider: auth[:provider], uid: auth[:uid]) }

      it 'returns correct user' do
        expect(User.from_omniauth(auth)).to eq user
      end

      it 'does not create new authentication' do
        expect{ User.from_omniauth(auth) }.to_not change(user.authentications, :count)
      end
    end

    context 'when hash does not contain email' do
      let(:user) { create(:user) }
      let(:authentication) {create(:authentication, user: user, provider: auth[:provider], uid: auth[:uid])}

      before { auth[:info].delete(:email) }

      it 'returns nil if user new' do
        expect(User.from_omniauth(auth)).to be_falsey
      end

      it 'returns user if user already has authentication' do
        authentication

        expect(User.from_omniauth(auth)).to eq user
      end
    end
  end

  describe '.provider?' do
    let(:user) { create(:user) }
    it 'returns true if oauth provider exist' do
      user.authentications.create! provider: 'twitter', uid: '12313'

      expect(user.provider?('twitter')).to be_truthy
    end

    it 'returns false it not' do
      expect(user.provider?('twitter')).to be_falsey
    end
  end
end
