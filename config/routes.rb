Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions" }
  root 'questions#index'

  concern :votable do
    member do
      get 'up'
      get 'down'
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, except: :index do
      get 'choice', on: :member
    end
  end
end
