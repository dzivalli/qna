require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  with_model :VotableModel do
    table do |t|
      t.integer :votes, null: false, default: 0
      t.belongs_to :user
    end

      model do
        include Votable
        belongs_to :user
      end
  end

  controller do
    before_action :authenticate_user!
    before_action :find_votable

    include Voted

    private

    def find_votable
      @anonymou = VotableModel.find params[:id]
    end
  end

  describe 'GET #up' do
    let(:votable) { VotableModel.create }
    before { routes.draw { get "custom" => "anonymous#up"} }

    context 'when user is authorized' do
      log_in

      before do

        xhr :get, :up, id: votable
        votable.reload
      end

      it 'increases vote counter to 1', format: :json do
        expect(votable.votes).to eq 1
      end

      it 'returns json object with votes', format: :json do
        expect(response.body).to eq votable.votes.to_s
      end
    end

    context 'when user is unauthorized' do
      before do
        xhr :get, :up, id: votable
        votable.reload
      end

      it 'does not change vote counter', format: :json do
        expect(votable.votes).to eq 0
      end

      it 'returns status 401', format: :json do
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when user is owner' do
      log_in

      before do
        votable.update user: @user
        xhr :get, :up, id: votable
        votable.reload
      end

      it 'does not change vote counter', format: :json do
        expect(votable.votes).to eq 0
      end

      it 'returns status 403' do
        expect(response).to have_http_status :forbidden
      end
    end

    context 'when authorized user vote several times' do
      log_in

      before do
        2.times { xhr :get, :up, id: votable }
        votable.reload
      end

      it 'increases votes counter by 1' do
        expect(votable.votes).to eq 1
      end

      it 'returns status 403' do
        expect(response).to have_http_status :forbidden
      end
    end
  end

  describe 'GET #down' do
    let(:votable) { VotableModel.create }
    before { routes.draw { get "custom" => "anonymous#down"} }

    context 'when user is authorized' do
      log_in

      before do
        xhr :get, :down, id: votable
        votable.reload
      end

      it 'decreases votes by 1' do
        expect(votable.votes).to eq -1
      end

      it 'returns json object with votes', format: :json do
        expect(response.body).to eq votable.votes.to_s
      end
    end

    context 'when user is unauthorized' do
      before do
        xhr :get, :down, id: votable
        votable.reload
      end

      it 'does not change vote counter', format: :json do
        expect(votable.votes).to eq 0
      end

      it 'returns status 401', format: :json do
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when user is owner' do
      log_in

      before do
        votable.update user: @user
        xhr :get, :down, id: votable
        votable.reload
      end

      it 'does not change vote counter', format: :json do
        expect(votable.votes).to eq 0
      end

      it 'returns status 403' do
        expect(response).to have_http_status :forbidden
      end
    end

    context 'when authorized user vote several times' do
      log_in

      before do
        2.times { xhr :get, :down, id: votable }
        votable.reload
      end

      it 'increases votes counter by 1' do
        expect(votable.votes).to eq -1
      end

      it 'returns status 403' do
        expect(response).to have_http_status :forbidden
      end
    end
  end

end