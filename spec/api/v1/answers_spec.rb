require 'rails_helper'

describe 'Answers API' do
  describe 'GET #index' do
    let!(:question) { create :question }

    it_behaves_like 'unauthenticated'

    context 'when user is authenticated' do
      let(:access_token) { create :oauth_access_token }
      let!(:answers) { create_list :answer, 2, question: question }
      subject { response.body }

      before { get "/api/v1/questions/#{question.id}/answers", access_token: access_token.token, format: :json  }

      it 'returns success' do
        expect(response).to be_success
      end

      it { is_expected.to have_json_size(2).at_path('answers')}

      %w(id body created_at).each do |attr|
        it { is_expected.to be_json_eql(answers.first.send(attr).to_json).at_path("answers/0/#{attr}")}
      end
    end

    def do_request(params = {})
      get "/api/v1/questions/#{question.id}/answers", {format: :json}.merge(params)
    end
  end

  describe 'GET #show' do
    let!(:question) { create :question }
    let!(:answer) { create :answer, question: question }

    it_behaves_like 'unauthenticated'

    context 'when user is authenticated' do
      let(:access_token) { create :oauth_access_token }
      let!(:comment) { create :comment, commentable: answer }
      let!(:attachment) { create :attachment, attachable: answer }
      subject { response.body }

      before { get "/api/v1/answers/#{answer.id}", access_token: access_token.token, format: :json }

      it 'returns success' do
        expect(response).to be_success
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

    def do_request(params = {})
      get "/api/v1/answers/#{answer.id}", {format: :json}.merge(params)
    end
  end

  describe 'POST #create' do
    let!(:question) { create :question }

    it_behaves_like 'unauthenticated'

    context 'when user is authenticated' do
      let(:user) { create :user }
      let(:access_token) { create :oauth_access_token, resource_owner_id: user.id }

      it 'returns success' do
        post "/api/v1/questions/#{question.id}/answers/", answer: attributes_for(:answer), access_token: access_token.token, format: :json
        expect(response).to be_success
      end

      it 'creates new answer' do
        expect {
          post "/api/v1/questions/#{question.id}/answers/", answer: attributes_for(:answer), access_token: access_token.token, format: :json
        }.to change(question.answers, :count).by 1
      end

      it 'creates answer with correct attributes' do
        post "/api/v1/questions/#{question.id}/answers/", answer: { body: '222' }, access_token: access_token.token, format: :json

        expect(response.body).to be_json_eql({body: '222'}.to_json)
                                     .excluding('attachments', 'comments').at_path('answer')
      end

      it 'belongs to user' do
        post "/api/v1/questions/#{question.id}/answers/", answer: attributes_for(:answer), access_token: access_token.token, format: :json
        expect(assigns(:answer).user).to eq user
      end
    end

    def do_request(params = {})
      post "/api/v1/questions/#{question.id}/answers/", {answer: attributes_for(:answer), format: :json}.merge(params)
    end
  end
end