Rails.application.routes.draw do
  
  root to: 'toppages#index'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:show, :create]
  
  get 'signin', to: 'sessions#new'
  post 'signin', to: 'sessions#create'
  delete 'signout', to: 'sessions#destroy'
  
#  resources :points, only: [:update]
  
  get 'points/new/:collection', to: 'points#new'
  post 'points/:collection', to: 'points#create'
  get 'points/show/:collection/:id', to: 'points#show'
  get 'points/:collection/:id/edit', to: 'points#edit'
  patch 'points/:collection/:id', to: 'points#update'
  delete 'points/:collection/:id/', to: 'points#destroy'
  
  resources :collections
  
end
