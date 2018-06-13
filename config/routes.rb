Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'receive', controller: :receive

  get 'patch/:user/:repo/:pr_number', controller: :patch, action: :index, as: 'patch'

  resource :setting, only: :show do
    resources :users
  end

  root to: "home#index"

  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'
end
