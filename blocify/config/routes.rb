Rails.application.routes.draw do
  resources :predictions

  get 'welcome/index'

  get 'welcome/about'

  root 'welcome#index'
end
