Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { sessions: "users/sessions",
                                    registrations: "users/registrations",
                                    omniauth_callbacks: "users/omniauth_callbacks" }

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
