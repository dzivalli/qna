require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'GET #new' do
    let(:commentable) { create(:question) }

    context 'when the user is authenticated' do
      log_in

      before { xhr :get, :new, question_id: commentable, format: :js }

      it 'build a new comment of given cammentable' do
        expect(assigns(:comment_decorator).comment).to be_a_new(Comment)
        expect(assigns(:comment_decorator).commentable).to be_a_kind_of(Question)
      end

      it 'renders new template' do
        expect(response).to render_template 'new'
      end
    end

    context 'when the user is not authenticated' do
      before { xhr :get, :new, question_id: commentable, format: :js }

      it 'returns unauthorized error' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'POST #create' do
    let(:commentable) { create(:question) }

    context 'when the user is authenticated' do
      log_in

      before { post :create, question_id: commentable, comment: { body: 'www'}, format: :js }

      it 'creates a new comment according to given params' do
        expect(commentable.comments.count).to eq 1
        expect(assigns(:comment_decorator).body).to eq 'www'
        expect(assigns(:comment_decorator).commentable).to be_a_kind_of(Question)
      end

      it 'render nothing' do
        expect(response).to render_template :create
      end
    end

    context 'when the user is authenticated but body blank' do
      log_in

      before { post :create, question_id: commentable, comment: { body: ''}, format: :js }

      it 'does not create a new comment' do
        expect(commentable.comments.count).to eq 0
      end

      it 'renders create template' do
        expect(response).to render_template :create
      end
    end

    context 'when the user is unauthenticated' do
      before { post :create, question_id: commentable, comment: { body: 'www'}, format: :js }

      it 'does not create a new comment' do
        expect(commentable.comments.count).to eq 0
      end

      it 'returns unauthorized error' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
