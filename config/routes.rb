Rails.application.routes.draw do
  get 'parties/index'
  get 'parties/show'
  get 'parties/new'
  get 'parties/create'
  get 'parties/edit'
  get 'parties/update'
  get 'parties/destroy'
  get 'parties/set_party'
  get 'parties/party_params'

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
