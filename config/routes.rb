Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions" }
  root 'questions#index'

  concern :votable do
    member do
      get 'up'
      get 'down'
    end
  end

  concern :commentable do
    resource :comments, only: [:new, :create]
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: :votable, except: :index do
      get 'choice', on: :member
    end
  end

  resources :answers, concerns: :commentable, only: []
end
