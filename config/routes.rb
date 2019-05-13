Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :books
  resources :publishers
  resources :authors
  resources :users
  get '/', to: 'landing#show'
  get '/reports/', to: 'reports#show'
  post '/users/:id/promote', to: 'users#promote'
  get 'login' ,to: 'sessions#login'
  post 'login', to: 'sessions#create'
  post 'search' ,to: 'search#create'
  get 'search' ,to: 'search#show'
  delete 'logout', to: 'sessions#logout'
  patch 'updatee', to: 'users#updatee'
  get '/cart/:id' , to: 'cart#show'
  delete '/cart/:book_id', to: 'cart#destroy'
  post 'cart/:book_id' , to: 'cart#create'
  get 'payment/:user_id', to: 'payment#show'
  post 'payment/:user_id', to: 'payment#create'
  get 'orders', to: 'orders#index'
  post 'orders/:id', to: 'orders#confirm'
  post 'orders/:book_id/:quantity', to: 'orders#create'
  delete 'orders/:id', to: 'orders#destroy'
end
