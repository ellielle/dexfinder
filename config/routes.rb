Rails.application.routes.draw do
  root 'pages#index'

  # TODO delete
  post 'boop', to: "pages#remove_me"
  # TODO delete

  resources :posts, param: :slug do
    resources :likes, only: [:create, :show, :destroy]
  end
  # get "#", to: "posts#get_post", as: :get_post  TODO repurpose for likes on posts#show
  get 'users/:username', to: "users#show", as: :user_profile
  get 'profile', to: "users#edit"
  post 'friends', to: "users#friends"
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
