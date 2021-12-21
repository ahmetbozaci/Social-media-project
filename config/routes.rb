Rails.application.routes.draw do

  root 'posts#index'

  devise_for :users 
  get "users/:id/profile", to: "users#profile", as: "profile"
  delete "users/:user_id/friendships/:id", to: "friendships#destroy", as: "delete"
  resources :users, only: [:index, :show] do
    resources :friendships, only: %i[create update]
  end
  resources :posts, only: [:index, :create] do
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
  end
  
  get "getPosts", to: "posts#getPosts"
  get "getComments/:post_id", to: "comments#getComments"
  post "postComment/:user_id/:post_id/:content", to: "comments#post_comment"
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
