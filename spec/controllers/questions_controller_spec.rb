require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  describe 'GET #index' do
    let(:questions) { create_list(:question, 4) }

    before do
      get :index
    end

    it 'should return all questions' do
      expect(assigns(:questions)).to match_array questions
    end

    it 'should render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    before do
      get :show, id: question
    end

    it 'should return question by its id' do
      expect(assigns(:question)).to eq question
    end

    it 'should render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    log_in

    before do
      get :new
    end

    it 'should return a new question' do
      expect(assigns(:question)).to be_a_new Question
    end

    it 'should render new template' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    log_in

    context 'with valid params' do
      it 'should create new questions' do
        expect { post :create, question: attributes_for(:question) }
            .to change(Question, :count).by 1
      end

      it 'should redirect to the new question path' do
        post :create, question: attributes_for(:question)

        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid params' do
      it 'should not create question' do
        expect { post :create, question: { body:nil, title: nil} }
            .to_not change(Question, :count)
      end

      it 'should re-render new template' do
        post :create, question: { body:nil, title: nil}

        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    log_in

    let(:question) { create(:question) }

    before do
      get :edit, id: question
    end

    it 'should return question by id' do
      expect(assigns(:question)).to eq question
    end

    it 'should render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    log_in

    context 'with valid params' do
      let(:question) { create(:question) }

      before do
        patch :update, id: question, question: {body: 'aaa', title: 'bbb'}
      end

      it 'should update the question by id' do
        expect(assigns(:question).body).to eq 'aaa'
        expect(assigns(:question).title).to eq 'bbb'
      end

      it 'should redirect to question path' do
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid params' do
      let(:question) { create(:question, body: 'aaa', title: 'bbb')}

      before do
        patch :update, id: question, question: {body: 'www', title: nil}
      end

      it 'should do not update question' do
        question.reload
        expect(question.body).to_not eq 'www'
        expect(question.title).to eq 'bbb'
      end

      it 'should re-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    log_in

    let(:question) { create(:question) }

    context 'should delete own question' do
      before do
        @user.questions << question
      end

      it 'should delete question by its id' do
        expect { delete :destroy, id: question }.to change(Question, :count).by -1
      end

      it 'should redirect to index page' do
        delete :destroy, id: question

        expect(response).to redirect_to questions_path
      end
    end

    context 'should not delete someone question' do
      let(:user2) { create(:user) }

      before do
        user2.questions << question
      end

      it 'should not delete someone question by id' do
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end

      it 'should redirect to back' do
        delete :destroy, id: question

        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
