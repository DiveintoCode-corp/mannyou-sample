Rails.application.routes.draw do
  root to: 'tasks#index'

  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show]

  resources :groups
  resources :joins, only: [:create, :destroy]

  resources :tasks

  resources :labels, except: [:show]

  namespace :admin do
    resources :users
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener"
end
