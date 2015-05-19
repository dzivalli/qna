require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    it 'searches globally by given words' do
      expect(Question).to receive(:search).with('word')
      get :index, q: 'word'
    end

    it 'searches only through given objects' do
      expect(Question).to receive(:search).with(conditions: {answers: 'word', questions: 'word'})
      get :index, q: 'word', conditions: ['answers', 'questions']
    end

    it 'renders index template' do
      get :index, q: 'word'
      expect(response).to render_template :index
    end
  end
end
