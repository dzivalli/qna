require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'when user is authenticated' do
      let(:me) { create :user }
      let(:access_token) { create :oauth_access_token, resource_owner_id: me.id }
      let!(:questions) { create_list :question, 2 }
      let!(:answer) { create :answer, question: questions.first }
      subject { response.body }

      before { get '/api/v1/questions', access_token: access_token.token, format: :json  }

      it 'returns success' do
        expect(response).to have_http_status :success
      end

      it { is_expected.to have_json_size(2).at_path('questions')}

      %w(id title body created_at votes).each do |attr|
        it { is_expected.to be_json_eql(questions.first.send(attr).to_json).at_path("questions/0/#{attr}")}
      end

      context 'when answers are existed' do
        it { is_expected.to have_json_size(1).at_path('questions/0/answers')}

        %w(id body).each do |attr|
          it { is_expected.to be_json_eql(answer.send(attr).to_json).at_path("questions/0/answers/0/#{attr}")}
        end
      end
    end

    context 'when user is unauthenticated' do
      it 'returns unauthorized error without access token' do
        get '/api/v1/questions', format: :json
        expect(response).to have_http_status :unauthorized
      end

      it 'returns unauthorized error with invalid access token' do
        get '/api/v1/questions', format: :json, access_token: 'sdfsfs'
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end