Rails.application.routes.draw do
  root 'pages#index'
  get 'users/:username', to: "users#show"
  get 'profile', to: "users#edit"
  post 'profile', to: "users#edit"
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
