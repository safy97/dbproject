Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :books;
  resources :users
  get 'login' ,to: 'sessions#login'
  post 'login', to: 'sessions#create'
  post 'search' ,to: 'search#create'
  get 'search' ,to: 'search#show'
  delete 'logout', to: 'sessions#logout'
  patch 'updatee', to: 'users#updatee'
end
