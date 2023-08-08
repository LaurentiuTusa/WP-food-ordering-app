Rails.application.routes.draw do
  get 'users/new'
  root "home#index"
  resources :about, only: :index
  get 'contact', to: 'contact#index'
  get 'service', to: 'service#index'
  get 'blog', to: 'blog#index'

  get 'apply_filters', to: 'home#apply_filters', as: :apply_filters

  get '/signup', to: 'users#new'
end
