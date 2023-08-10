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
  resources :users
end
