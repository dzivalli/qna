require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'GET #new' do
    let(:question) { create(:question) }

    context 'when the user is authenticated' do
      log_in

      before { xhr :get, :new, question_id: question, format: :js }

      it 'build a new comment' do
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      it 'renders new template' do
        expect(response).to render_template 'new'
      end
    end

    context 'when the user is not authenticated' do
      before { xhr :get, :new, question_id: question, format: :js }

      it 'does not create new comment' do
        expect(assigns(:comment)).to_not be_a_new(Comment)
      end

      it 'returns unauthorized error' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'when the user is authenticated' do
      log_in

      before { post :create, question_id: question, comment: { body: 'www'}, format: :js }

      it 'creates a new comment with given params' do
        expect(question.comments.count).to eq 1
        expect(assigns(:comment).body).to eq 'www'
      end

      it 'render nothing' do
        expect(response).to render_template :create
      end
    end

    context 'when the user is authenticated but body blank' do
      log_in

      before { post :create, question_id: question, comment: { body: ''}, format: :js }

      it 'does not create a new comment' do
        expect(question.comments.count).to eq 0
      end

      it 'renders create template' do
        expect(response).to render_template :create
      end
    end

    context 'when the user is unauthenticated' do
      before { post :create, question_id: question, comment: { body: 'www'}, format: :js }

      it 'does not create a new comment' do
        expect(question.comments.count).to eq 0
      end

      it 'returns unauthorized error' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
