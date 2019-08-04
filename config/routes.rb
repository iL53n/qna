Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
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

  concern :commentable do
    resources :comments, only: :create, shallow: true
  end

  resources :questions, concerns: %i[voteable commentable] do
    resources :answers, shallow: true, concerns: %i[voteable commentable] do
      member do
        patch :best
      end
    end
  end

  mount ActionCable.server => '/cable'
end
