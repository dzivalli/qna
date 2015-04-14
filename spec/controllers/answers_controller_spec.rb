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

    it { is_expected.to render_template :new }
  end

  describe 'POST #create' do
    log_in

    context 'when valid parameters' do
      it 'creates a new answer' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :json }
            .to change(question.answers, :count).by(1)
      end

      it 'belongs to user who created it' do
        post :create, question_id: question, answer: {body: 'www'}, format: :json

        expect(Answer.find_by_body('www').user).to eq @user
      end

      it 'builds new answer' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :json

        expect(assigns(:answer_new)).to be_a_new(Answer)
      end

      it 'answers with status 200' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :json

        expect(response).to have_http_status 200
      end
    end

    context 'when invalid parameters' do
      it 'does not create a new answer' do
        expect { post :create, question_id: question, answer: {body: nil}, format: :json }
            .to_not change(Answer, :count)
      end

      it 'answers with status 422' do
        post :create, question_id: question, answer: {body: nil}, format: :json

        expect(response).to have_http_status 422
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

    it { is_expected.to render_template :edit }
  end

  describe 'PATCH #update' do
    let(:user2) { create(:user) }
    log_in

    before { answer.update user: @user }

    context 'when valid parameters' do
      before do
        patch :update, question_id: question, id: answer, answer: {body: 'aaa'}, format: :js
      end

      it 'updates answer with given params' do
        answer.reload
        expect(answer.body).to eq 'aaa'
      end

      it { is_expected.to render_template :update }
    end

    context 'when invalid parameters' do
      it 'does not update answer' do
        patch :update, question_id: question, id: answer, answer: {body: nil}, format: :js

        answer.reload
        expect(answer.body).to be_truthy
        # expect { post :update, question_id: question, id: answer, answer: {body: nil}, format: :js }
        #     .to_not change(answer, :body)
      end

      it 'renders update template' do
        patch :update, question_id: question, id: answer, answer: {body: nil}, format: :js

        expect(response).to render_template :update
      end
    end

    context 'when answer belongs to someone else' do
      it 'does not edit answer' do
        answer.update user: user2
        patch :update, question_id: question, id: answer, answer: { body: 'www' }, format: :js

        answer.reload
        expect(answer.body).to_not eq 'www'
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
        expect { delete :destroy, question_id: question, id: answer, format: :js }
            .to change(question.answers, :count).by(-1)
      end
    end

    context 'when delete someone answer' do
      it 'does not delete answer by id' do
        answer
        expect { delete :destroy, question_id: question, id: answer, format: :js }
            .to_not change(Answer, :count)
      end
    end
  end

  describe 'GET #choice' do
    log_in

    context 'when user is question owner' do
      before do
        question.answers << answer
        @user.questions << question

        xhr :get, :choice, question_id: question, id: answer, format: :js
      end

      it 'updates answer best to true' do
        answer.reload
        expect(answer.best).to be_truthy
      end

      it { is_expected.to render_template :choice }
    end

    context 'when user is not owner' do
      before { xhr :get, :choice, question_id: question, id: answer, format: :js }

      it 'does not update answer on question' do
        answer.reload
        expect(answer.best).to be_falsey
      end

      it { is_expected.to render_template :choice }
    end
  end

end
