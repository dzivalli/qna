require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'when user is authenticated' do
      let(:me) { create :user }
      let(:access_token) { create :oauth_access_token, resource_owner_id: me.id }
      subject { response.body }

      before { get '/api/v1/profiles/me', access_token: access_token.token, format: :json  }

      it 'returns success' do
        expect(response).to be_success
      end

      %w(id email).each do |attr|
        it { is_expected.to be_json_eql(me.send(attr).to_json).at_path(attr)}
      end

      %w(password encrypted_password).each do |attr|
        it { is_expected.to_not have_json_path(attr) }
      end
    end

    context 'when user is unauthenticated' do
      it 'returns unauthorized error without access token' do
        get '/api/v1/profiles/me', format: :json
        expect(response).to have_http_status :unauthorized
      end

      it 'returns unauthorized error with invalid access token' do
        get '/api/v1/profiles/me', format: :json, access_token: 'sdfsfs'
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'GET /index' do
    context 'when user is unauthenticated' do
      it 'returns unauthorized error without access token' do
        get '/api/v1/profiles', format: :json
        expect(response).to have_http_status :unauthorized
      end

      it 'returns unauthorized error with invalid access token' do
        get '/api/v1/profiles', access_token: '12412', format: :json
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when user is authenticated' do
      let(:me) { create :user }
      let(:access_token) { create :oauth_access_token, resource_owner_id: me.id }
      let!(:others) { create_list :user, 2 }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'returns success' do
        expect(response).to be_success
      end

      %w(id email).each do |attr|
        it "contains #{attr}" do
          others.each_with_index do |user, i|
            expect(response.body).to be_json_eql(user.send(attr).to_json).at_path("profiles/#{i}/#{attr}")
          end
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          others.each_with_index do |_, i|
            expect(response.body).to_not have_json_path("profiles/#{i}/#{attr}")
          end
        end
      end
    end
  end
end