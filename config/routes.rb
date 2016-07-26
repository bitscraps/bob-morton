Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'receive', controller: :receive

  get 'patch/:user/:repo/:pr_number', controller: :patch, action: :index
end
