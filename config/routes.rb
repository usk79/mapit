Rails.application.routes.draw do
  
  root to: 'toppages#index'
  
  get 'my_collections', to: 'toppages#my_collections'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:show, :create]
  
  get 'signin', to: 'sessions#new'
  post 'signin', to: 'sessions#create'
  delete 'signout', to: 'sessions#destroy'
  
  resources :points, only: [:new, :create, :show, :edit, :update, :destroy]
  
end
