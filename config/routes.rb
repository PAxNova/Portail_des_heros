Rails.application.routes.draw do

  devise_for :users
  root to: "pages#home"

  # Limiter le nombre de routes
  resources :characters

  # Les routes pour notre lexique (Post)
  resources :posts, only: [:index, :show]

  #routes vers les tutos
  resources :universes do
    member do
      get :tutorials
    end
  end

  # list des tutos
  resources :tutorials, only: [:index]
end
