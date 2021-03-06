Rails.application.routes.draw do
  
  root to: 'toppages#index'
  get 'toppage', to: 'toppages#index'
  get 'everyones/:id', to: 'toppages#show'
  get 'help', to: 'toppages#help'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:show, :create]
  
  get 'signin', to: 'sessions#new'
  post 'signin', to: 'sessions#create'
  delete 'signout', to: 'sessions#destroy'
  
  get 'points/new/:collection', to: 'points#new'
  post 'points/:collection', to: 'points#create'
  get 'points/show/:collection/:id', to: 'points#show'
  get 'points/:collection/:id/edit', to: 'points#edit'
  patch 'points/:collection/:id', to: 'points#update'
  delete 'points/:collection/:id/', to: 'points#destroy'
  
  resources :collections
  get 'collection_info/:id', to: 'collections#info'
  get 'show_public', to: 'collections#show_public'
  
  resources :collection_relationships, only: [:create, :destroy]
  
  resources :comments, only: [:create, :destroy]
  
end
