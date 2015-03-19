require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #new' do
    log_in

    before do
      get :new, question_id: question
    end

    it 'returns a new answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'renders a new template' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    log_in

    context 'when valid parameters' do
      it 'creates a new answer' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }
            .to change(question.answers, :count).by(1)
      end

      it 'belongs to user who created it' do
        post :create, question_id: question, answer: {body: 'www'}

        expect(Answer.find_by_body('www').user).to eq @user
      end

      it 'redirects to question page' do
        post :create, question_id: question, answer: attributes_for(:answer)

        expect(response).to redirect_to question_path(question)
      end
    end

    context 'when invalid parameters' do
      it 'does not create a new answer' do
        expect { post :create, question_id: question, answer: {body: nil} }
            .to_not change(Answer, :count)
      end

      it 're-renders new template' do
        post :create, question_id: question, answer: {body: nil}

        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    log_in

    before do
      get :edit, question_id: question, id: answer
    end

    it 'returns answer by id' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit template' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #update' do
    log_in

    context 'when valid parameters' do
      before do
        post :update, question_id: question, id: answer, answer: {body: 'aaa'}
      end

      it 'updates answer with given params' do
        answer.reload
        expect(answer.body).to eq 'aaa'
      end

      it 'redirects to question page' do
        expect(response).to redirect_to question
      end
    end

    context 'when invalid parameters' do
      it 'does not update answer' do
        expect { post :update, question_id: question, id: answer, answer: {body: nil} }
            .to_not change(answer, :body)
      end

      it 're-renders new template' do
        post :update, question_id: question, id: answer, answer: {body: nil}

        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    log_in

    let(:user2) { create(:user, answers: answer) }

    context 'when delete own answer' do
      before do
        @user.answers << answer
      end

      it 'deletes answer by id' do
        expect { delete :destroy, question_id: question, id: answer }
            .to change(question.answers, :count).by(-1)
      end

      it 'redirects to question page' do
        delete :destroy, question_id: question, id: answer

        expect(response).to redirect_to question
      end
    end

    context 'when delete someone answer' do
      it 'does not delete answer by id' do
        answer
        expect { delete :destroy, question_id: question, id: answer }
            .to_not change(Answer, :count)
      end
    end
  end

end
