require 'rails_helper'

describe 'Answers API' do
  describe 'GET #index' do
    let!(:question) { create :question }

    context 'when user is unauthenticated' do
      it 'returns unauthorized error without access token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response).to have_http_status :unauthorized
      end

      it 'returns unauthorized error with invalid access token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: 'sdfsfs'
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when user is authenticated' do
      let(:access_token) { create :oauth_access_token }
      let!(:answers) { create_list :answer, 2, question: question }
      subject { response.body }

      before { get "/api/v1/questions/#{question.id}/answers", access_token: access_token.token, format: :json  }

      it 'returns success' do
        expect(response).to have_http_status :success
      end

      it { is_expected.to have_json_size(2).at_path('answers')}

      %w(id body created_at).each do |attr|
        it { is_expected.to be_json_eql(answers.first.send(attr).to_json).at_path("answers/0/#{attr}")}
      end
    end
  end

  describe 'GET #show' do
    let!(:question) { create :question }
    let!(:answer) { create :answer, question: question }

    context 'when user is unauthenticated' do
      it 'returns unauthorized error without access token' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json
        expect(response).to have_http_status :unauthorized
      end

      it 'returns unauthorized error with invalid access token' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: 'sdfsfs'
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when user is authenticated' do
      let(:access_token) { create :oauth_access_token }
      let!(:comment) { create :comment, commentable: answer }
      let!(:attachment) { create :attachment, attachable: answer }
      subject { response.body }

      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", access_token: access_token.token, format: :json }

      it 'returns success' do
        expect(response).to have_http_status :success
      end

      %w(id body created_at).each do |attr|
        it { is_expected.to be_json_eql(answer.send(attr).to_json).at_path("answer/#{attr}")}
      end

      context 'when comments are exist' do
        it { is_expected.to have_json_size(1).at_path('answer/comments')}

        %w(id body created_at).each do |attr|
          it { is_expected.to be_json_eql(comment.send(attr).to_json).at_path("answer/comments/0/#{attr}")}
        end
      end

      context 'when attachments are exist' do
        it { is_expected.to have_json_size(1).at_path('answer/attachments')}
        it { is_expected.to be_json_eql(attachment.file.url.to_json).at_path('answer/attachments/0/url')}

        %w(id created_at).each do |attr|
          it { is_expected.to be_json_eql(attachment.send(attr).to_json).at_path("answer/attachments/0/#{attr}")}
        end
      end
    end
  end
end