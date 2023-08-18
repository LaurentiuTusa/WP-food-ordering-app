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
  get '/view_cart', to: 'orders#view_cart', as: :view_cart
  delete '/remove_product_from_cart/:order_item_id', to: 'orders#remove_product_from_cart', as: :remove_product_from_cart

  resources :users
  resources :account_activations, only: [:edit]

  get 'admin/view_orders', to: 'admin#view_orders', as: :view_orders
  delete 'admin/destroy_order/:id', to: 'admin#destroy_order', as: :destroy_order
  post 'admin/mark_order_as_handled/:id', to: 'admin#mark_order_as_handled', as: :mark_order_as_handled

  get 'admin/view_users', to: 'admin#view_users', as: :view_users
  get 'admin/view_profile/:id', to: 'admin#view_profile', as: :view_profile
  delete 'admin/destroy_user/:id', to: 'admin#destroy_user', as: :destroy_user

  get 'admin/view_products', to: 'admin#view_products', as: :view_products
  get 'admin/create_product', to: 'admin#create_product', as: :create_product
  post 'admin/create_product', to: 'admin#create_product'
  post 'admin/edit_product/:id', to: 'admin#edit_product', as: :edit_product
  patch 'admin/update_product/:id', to: 'admin#update_product', as: :update_product
  delete 'admin/destroy_product/:id', to: 'admin#destroy_product', as: :destroy_product
end
