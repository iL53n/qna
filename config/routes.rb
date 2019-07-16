Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  concern :voteable do
    member do
      post :up
      post :down
      post :cancel
    end
  end

  resources :questions, concerns: [:voteable] do
    resources :answers, concerns: [:voteable], shallow: true do
      member do
        patch :best
      end
    end
  end
end
