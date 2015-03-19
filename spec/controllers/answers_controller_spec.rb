require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #new' do
    log_in

    before do
      get :new, question_id: question
    end

    it 'should return new answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'should render new template' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    log_in

    context 'with valid parameters' do
      it 'should create new answer' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }
            .to change(question.answers, :count).by(1)
      end

      it 'should redirect to question page' do
        post :create, question_id: question, answer: attributes_for(:answer)

        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid parameters' do
      it 'should not create new answer' do
        expect { post :create, question_id: question, answer: {body: nil} }
            .to_not change(Answer, :count)
      end
      it 'should re-render new template' do
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

    it 'should return answer by id' do
      expect(assigns(:answer)).to eq answer
    end
    it 'should render edit template' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #update' do
    log_in

    context 'with valid parameters' do
      before do
        post :update, question_id: question, id: answer, answer: {body: 'aaa'}
      end

      it 'should update answer with given params' do
        answer.reload
        expect(answer.body).to eq 'aaa'
      end
      it 'should redirect to question page' do
        expect(response).to redirect_to question
      end
    end

    context 'with invalid parameters' do
      it 'should not update answer' do
        expect { post :update, question_id: question, id: answer, answer: {body: nil} }
            .to_not change(answer, :body)
      end
      it 'should re-render new template' do
        post :update, question_id: question, id: answer, answer: {body: nil}

        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    log_in

    let(:user2) { create(:user, answers: answer) }

    context 'delete own answer' do
      before do
        @user.answers << answer
      end

      it 'should delete answer by id' do
        expect { delete :destroy, question_id: question, id: answer }
            .to change(question.answers, :count).by(-1)
      end
      it 'should redirect to question page' do
        delete :destroy, question_id: question, id: answer

        expect(response).to redirect_to question
      end
    end

    context 'delete someone answer' do
      it 'should not delete answer by id' do
        answer
        expect { delete :destroy, question_id: question, id: answer }
            .to_not change(question.answers, :count)
      end
    end
  end

end
