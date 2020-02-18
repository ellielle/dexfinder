Rails.application.routes.draw do
  root 'pages#index'

  # TODO delete
  post 'boop', to: "pages#remove_me"
  # TODO delete

  get 'users/:username', to: "users#show", as: :user_profile, constraints: { username: /[0-z\.]+/ }
  get 'profile', to: "users#profile", as: :self_profile
  get 'edit', to: "users#edit", as: :self_edit
  post 'friends', to: "users#friends"
  post 'friend_request', to: "users#friend_request"
  post 'upload', to: "users#upload"
  resources :users, only: :update
  resources :posts, param: :slug do
    resources :likes, only: [:create, :show, :destroy]
    resources :comments, only: [:new, :create, :destroy]
  end
  resources :comments, only: [:new, :create, :destroy] do
    resources :comments, only: [:new, :create, :destroy]
  end
  # Devise routes
  devise_for :users, path: "account", controllers: {
      registrations: 'users/registrations'
  }
  devise_scope :user do
    get 'sign_in', to: "devise/sessions#new"
    get 'sign_up', to: "users/registrations#new"
    get 'sign_out', to: "devise/sessions#destroy"
  end
end
