Rails.application.routes.draw do
  get '/agreement' => 'home#agreement'

  # root 'posts#index'
  get 'posts/new' => 'posts#new'
  post 'posts/create' => 'posts#create'
  post 'posts/:random_key/destroy' => 'posts#destroy'
  post 'posts/:random_key/check' => 'posts#check_answer'
  get 'posts/:random_key' => 'posts#show'

  post 'comments/:random_key/create' => 'comments#create'

  get 'users/:nickname/edit' => 'users#edit'
  patch 'users/:nickname/update' => 'users#update'
  root 'users#new'
  post 'users/create/:auth' => 'users#create'
  get 'users/:nickname' => 'users#show'
  get '/auth/:provider/callback' => 'users#create'
  post 'logout' => 'users#logout'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
