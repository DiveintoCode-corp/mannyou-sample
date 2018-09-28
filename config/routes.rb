Rails.application.routes.draw do
  root to: 'tasks#index'

  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show]

  resources :groups
  resources :joins, only: [:create, :destroy]

  resources :tasks
  namespace :groups do
    resources :tasks, only: [:index, :destroy]
  end

  resources :labels, except: [:show]

  namespace :admin do
    resources :users
  end
end
