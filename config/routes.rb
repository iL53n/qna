require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  root to: 'questions#index'

  get :search, to: 'search#result'

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  devise_for :users, controllers: {
      omniauth_callbacks: 'oauth_callbacks',
      confirmations: 'oauth_confirmations'
  }

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, except: %i[new edit] do
        resources :answers, except: %i[new edit], shallow: true
      end
    end
  end

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
    resources :subscriptions, only: %i[create destroy], shallow: true
  end

  mount ActionCable.server => '/cable'
end
