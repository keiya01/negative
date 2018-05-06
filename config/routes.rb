Rails.application.routes.draw do
  root 'posts#index'
  get 'posts/new' => 'posts#new'
  post 'posts/create' => 'posts#create'
  post 'posts/:id/destroy' => 'posts#destroy'
  get 'posts/:id/check' => 'posts#check_answer'
  get 'posts/:id' => 'posts#show'

  post 'comments/:id/create' => 'comments#create'

  get 'users/:nickname/edit' => 'users#edit'
  patch 'users/:nickname/update' => 'users#update'
  get 'signup' => 'users#new'
  get 'users/:nickname' => 'users#show'
  get 'auth/:provider/callback' => 'users#create'
  post 'logout' => 'users#logout'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
