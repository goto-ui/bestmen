# frozen_string_literal: true

Rails.application.routes.draw do
  # devise_for :users
  root to: 'home#top'
  get  '/about', to: 'home#about'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  
  devise_scope :user do
    get 'sign_in', to: 'users/sessions#new'
    get 'sign_out', to: 'users/sessions#destroy'
  end

  resources :users, only: [:index, :show]
  
  resources :pics do
    member do
      put "like", to: "pics#like"
      put "unlike", to: "pics#unlike"
    end
    resources :comments
  end
  
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
