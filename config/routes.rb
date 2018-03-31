Rails.application.routes.draw do
  
  root to: 'toppages#index'
  
  get 'dummy', to: 'toppages#dummy'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:show, :create]
  
  get 'signin', to: 'sessions#new'
  post 'signin', to: 'sessions#create'
  delete 'signout', to: 'sessions#destroy'
  
  resources :points, only: [:new, :create]
  
end
