require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  describe 'GET #index' do
    let(:questions) { create_list(:question, 4) }

    before do
      get :index
    end

    it 'returns all questions' do
      expect(assigns(:questions)).to match_array questions
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    before do
      get :show, id: question
    end

    it 'returns question by its id' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    log_in

    before do
      get :new
    end

    it 'returns a new question' do
      expect(assigns(:question)).to be_a_new Question
    end

    it 'renders a new template' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    log_in

    context 'when valid params' do
      it 'creates a new question' do
        expect { post :create, question: attributes_for(:question) }
            .to change(Question, :count).by 1
      end

      it 'belongs to user who created it' do
        post :create, question: {title: 'www', body: 'eee'}

        expect(Question.find_by_title('www').user).to eq @user
      end

      it 'redirects to the new question path' do
        post :create, question: attributes_for(:question)

        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'publish question to public_pub' do
        expect(PrivatePub).to receive(:publish_to).with('/questions', question: kind_of(Question))

        post :create, question: attributes_for(:question)
      end
    end

    context 'when invalid params' do
      it 'does not create question' do
        expect { post :create, question: { body:nil, title: nil} }
            .to_not change(Question, :count)
      end

      it 're-renders a new template' do
        post :create, question: { body:nil, title: nil}

        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    log_in

    let(:question) { create(:question) }

    before do
      get :edit, id: question, format: :js
    end

    it 'returns question by id' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    log_in

    context 'when valid params' do
      let(:question) { create(:question, user: @user) }

      before do
        patch :update, id: question, question: {body: 'aaa', title: 'bbb'}, format: :js
      end

      it 'updates the question by id' do
        expect(assigns(:question).body).to eq 'aaa'
        expect(assigns(:question).title).to eq 'bbb'
      end

      it 'redirects to question path' do
        expect(response).to render_template :update
      end
    end

    context 'when invalid params' do
      let(:question) { create(:question, user: @user, body: 'aaa', title: 'bbb')}

      before do
        patch :update, id: question, question: {body: 'www', title: nil}, format: :js
      end

      it 'does not update question' do
        question.reload
        expect(question.body).to_not eq 'www'
        expect(question.title).to eq 'bbb'
      end

      it 're-renders edit view' do
        expect(response).to render_template :update
      end
    end

    context 'when question belongs to another user' do
      let(:user2) { create(:user) }
      let(:question) { create(:question, user: user2) }

      it 'returns an error' do
        patch :update, id: question, question: {body: 'aaa', title: 'bbb'}, format: :js

        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'DELETE #destroy' do
    log_in

    let(:question) { create(:question) }

    context 'when delete own question' do
      before do
        @user.questions << question
      end

      it 'deletes question by its id' do
        expect { delete :destroy, id: question }.to change(Question, :count).by -1
      end

      it 'redirects to index page' do
        delete :destroy, id: question

        expect(response).to redirect_to questions_path
      end
    end

    context 'when delete someone question' do
      let(:user2) { create(:user, question: question) }

      it 'returns an error' do
        delete :destroy, id: question

        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
