# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "landing#index"
  
  match '/about', to: 'landing#about', via: :get
  match '/register', to: 'users#new', via: :get
  match '/login', to: 'users#login_form', via: :get
  match '/login', to: 'users#login_user', via: :post
  match '/user', to: 'dashboard#show', via: :get
  match '/logout', to: 'dashboard#index', via: :get
  get '/discover', to: 'discover#search'
  
  resources :users, only: %i[create] do
  end

  resources :movies, only: [:show] do
    resources :viewing_parties, only: %i[new create]
  end
  
  resources :movies, only: [:show]
end
