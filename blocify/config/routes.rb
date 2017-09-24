Rails.application.routes.draw do
  resources :predictions

  resources :endpoints, only: [:new, :create, :destroy]

  get 'welcome/index'

  get 'welcome/about'

  root 'welcome#index'
end
