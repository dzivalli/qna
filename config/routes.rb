Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions do
    resources :answers, except: :index do
      get 'choice', on: :member
    end

    member do
      get 'up'
      get 'down'
    end
  end
end
