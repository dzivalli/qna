require 'rails_helper'

describe 'Questions API' do
  describe 'GET #index' do
    context 'when user is authenticated' do
      let(:access_token) { create :oauth_access_token }
      let!(:questions) { create_list :question, 2 }
      subject { response.body }

      before { get '/api/v1/questions', access_token: access_token.token, format: :json  }

      it 'returns success' do
        expect(response).to be_success
      end

      it { is_expected.to have_json_size(2).at_path('questions')}

      %w(id title body created_at votes).each do |attr|
        it { is_expected.to be_json_eql(questions.first.send(attr).to_json).at_path("questions/0/#{attr}")}
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

  describe 'GET #show' do
    let!(:question) { create :question }

    context 'when user is unauthenticated' do
      it 'returns unauthorized error without access token' do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response).to have_http_status :unauthorized
      end

      it 'returns unauthorized error with invalid access token' do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: 'sdfsfs'
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when user is authenticated' do
      let(:access_token) { create :oauth_access_token }
      let!(:comment) { create :comment, commentable: question}
      let!(:attachment) { create :attachment, attachable: question}
      subject { response.body }

      before { get "/api/v1/questions/#{question.id}", access_token: access_token.token, format: :json  }

      it 'returns success' do
        expect(response).to be_success
      end

      %w(id title body created_at votes).each do |attr|
        it { is_expected.to be_json_eql(question.send(attr).to_json).at_path("question/#{attr}")}
      end

      context 'when comments are exist' do
        it { is_expected.to have_json_size(1).at_path('question/comments')}

        %w(id body created_at).each do |attr|
          it { is_expected.to be_json_eql(comment.send(attr).to_json).at_path("question/comments/0/#{attr}")}
        end
      end

      context 'when attachments are exist' do
        it { is_expected.to have_json_size(1).at_path('question/attachments')}
        it { is_expected.to be_json_eql(attachment.file.url.to_json).at_path('question/attachments/0/url')}

        %w(id created_at).each do |attr|
          it { is_expected.to be_json_eql(attachment.send(attr).to_json).at_path("question/attachments/0/#{attr}")}
        end
      end
    end
  end

  describe 'POST #create' do
    context 'when user is unauthenticated' do
      it 'returns unauthorized error without access token' do
        post '/api/v1/questions', question: attributes_for(:question), format: :json
        expect(response).to have_http_status :unauthorized
      end

      it 'returns unauthorized error with invalid access token' do
        post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: 'sdfsfs'
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when user is authenticated' do
      let(:user) { create :user }
      let(:access_token) { create :oauth_access_token, resource_owner_id: user.id }

      it 'returns success' do
        post '/api/v1/questions', question: attributes_for(:question), access_token: access_token.token, format: :json
        expect(response).to be_success
      end

      it 'creates new question' do
        expect {
          post '/api/v1/questions', question: attributes_for(:question), access_token: access_token.token, format: :json
        }.to change(Question, :count).by 1
      end

      it 'creates question with correct attributes' do
        post '/api/v1/questions', question: { title: '111', body: '222' }, access_token: access_token.token, format: :json

        expect(response.body).to be_json_eql({title: '111', body: '222', votes: 0}.to_json)
                                     .excluding('answers', 'attachments', 'comments').at_path('question')
      end

      it 'belongs to user' do
        post '/api/v1/questions', question: attributes_for(:question), access_token: access_token.token, format: :json
        expect(assigns(:question).user).to eq user
      end
    end

  end
end