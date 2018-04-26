Rails.application.routes.draw do
  root 'posts#index'
  get 'posts/new' => 'posts#new'
  post 'posts/create' => 'posts#create'
  post 'posts/:id/destroy' => 'posts#destroy'

  post 'comments/:id/create' => 'comments#create'

  get 'signup' => 'users#new'
  get 'auth/:provider/callback' => 'users#create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
