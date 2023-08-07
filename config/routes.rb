Rails.application.routes.draw do
  root "home#index"
  get 'about', to: 'about#index'
  get 'contact', to: 'contact#index'
  get 'service', to: 'service#index'
  get 'blog', to: 'blog#index'

  get 'apply_filters', to: 'home#apply_filters', as: :apply_filters
end
