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

      it 'returns json with answer' do
        post :create, question_id: question, answer: {body: 'www'}, format: :json

        expect(response.body).to  eq(assigns(:answer).to_json(include: :attachments))
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
        patch :update, question_id: question, id: answer, answer: {body: 'aaa'}, format: :json

        answer.reload
      end

      it 'updates answer with given params' do
        expect(answer.body).to eq 'aaa'
      end

      it 'returns json with answer' do
        expect(response.body).to eq assigns(:answer).to_json(include: :attachments)
      end
    end

    context 'when invalid parameters' do
      it 'does not update answer' do
        patch :update, question_id: question, id: answer, answer: {body: nil}, format: :json

        answer.reload
        expect(answer.body).to be_truthy
      end

      it 'answers with 422 status' do
        patch :update, question_id: question, id: answer, answer: {body: nil}, format: :json

        expect(response).to have_http_status :unprocessable_entity
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

  describe 'GET #up' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    context 'when user is authorized' do
      log_in

      before do
        xhr :get, :up, question_id: question, id: answer
        answer.reload
      end

      it 'increases vote counter to 1', format: :json do
        expect(answer.votes).to eq 1
      end

      it_behaves_like 'returnable json object with answer votes'
    end

    context 'when user is unauthorized' do
      before do
        xhr :get, :up, question_id: question, id: answer
        answer.reload
      end

      it_behaves_like 'did not changed answer votes'
      it_behaves_like 'unauthorized'
    end

    context 'when user is owner' do
      log_in

      before do
        @user.answers << answer
        xhr :get, :up, question_id: question, id: answer
        answer.reload
      end

      it_behaves_like 'did not changed answer votes'
      it_behaves_like 'forbidden'
    end

    context 'when authorized user vote several times' do
      log_in

      before do
        2.times { xhr :get, :up, question_id: question, id: answer }
        answer.reload
      end

      it 'increases votes counter by 1' do
        expect(answer.votes).to eq 1
      end

      it_behaves_like 'forbidden'
    end
  end

  describe 'GET #down' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer) }

    context 'when user is authorized' do
      log_in

      before do
        xhr :get, :down, question_id: question, id: answer
        answer.reload
      end

      it 'decreases votes by 1' do
        expect(answer.votes).to eq -1
      end

      it_behaves_like 'returnable json object with answer votes'
    end

    context 'when user is unauthorized' do
      before do
        xhr :get, :down, question_id: question, id: answer
        answer.reload
      end

      it_behaves_like 'did not changed answer votes'
      it_behaves_like 'unauthorized'
    end

    context 'when user is owner' do
      log_in

      before do
        @user.answers << answer
        xhr :get, :down, question_id: question, id: answer
        answer.reload
      end

      it_behaves_like 'did not changed answer votes'
      it_behaves_like 'forbidden'
    end

    context 'when authorized user vote several times' do
      log_in

      before do
        2.times { xhr :get, :down, question_id: question, id: answer }
        answer.reload
      end

      it 'increases votes counter by 1' do
        expect(answer.votes).to eq -1
      end

      it_behaves_like 'forbidden'
    end
  end
end
