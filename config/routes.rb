Rails.application.routes.draw do
  get 'users/new'
  root "home#index"
  resources :about, only: :index
  resources :contact, only: :index
  resources :service, only: :index
  resources :blog, only: :index

  get 'apply_filters', to: 'home#apply_filters', as: :apply_filters

  get '/signup', to: 'users#new'
  get '/show', to: 'users#show'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/add_to_cart/:product_id', to: 'orders#add_to_cart', as: :add_to_cart
  get '/create_order', to: 'orders#convert_cart_to_order', as: :create_order
  resources :users
  resources :account_activations, only: [:edit]
end
