require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  describe 'POST #create' do
    let(:question) { create :question }

    context 'when user is not authenticated' do
      it 'does not create new notification' do
        expect { post :create, question_id: question, format: :js }.to_not change(Notification, :count)
      end

      it 'returns unauthorized error' do
        post :create, question_id: question, format: :js
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when user is authenticated' do
      log_in

      it 'creates one new notification' do
        expect { post :create, question_id: question, format: :js }.to change(Notification, :count).by 1
      end

      it 'belongs to user and question' do
        post :create, question_id: question, format: :js

        expect(assigns(:notification).user).to eq @user
        expect(assigns(:notification).question).to eq question
      end

      it 'renders create template' do
        post :create, question_id: question, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:question) { create :question }
    let!(:notification) { create :notification, question: question}

    context 'when user is not authenticated' do
      it 'does not delete notification' do
        expect { delete :destroy, question_id: question, id: notification, format: :js }.to_not change(Notification, :count)
      end

      it 'returns unauthorized error' do
        delete :destroy, question_id: question, id: notification, format: :js
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when user is authenticated' do
      log_in

      before { @user.notifications << notification }

      it 'deletes notification' do
        expect { delete :destroy, question_id: question, id: notification, format: :js }.to change(Notification, :count).by -1
      end

      it 'renders destroy template' do
        delete :destroy, question_id: question, id: notification, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

end
