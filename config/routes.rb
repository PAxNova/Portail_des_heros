# config/routes.rb
require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users
  root to: "pages#home"

  # A FAIRE : Limiter le nombre de routes pour des questions de sécurité
  resources :characters, path: 'mes_personnages' do
    member do
      get 'image' # route pour afficher l'image générée par IA
      get :backstory_partial # route pour afficher le contenu de l'histoire générée par IA
    end
  end

  resources :parties, path: 'mes_parties' do
    resources :messages, only: :create
  end

  # Création d'une route pour afficher tous les personnages créés sur le serveur
  get '/tous_les_personnages', to: 'characters#all_characters', as: 'tous_les_personnages'

  # Routes pour notre lexique (Post)
  resources :posts, only: [:index, :show]

  # Routes vers les tutos
  resources :universes do
    member do
      get :tutorials
    end
  end

  # Liste des tutos
  resources :tutorials, only: [:index]

  mount ActionCable.server => '/cable'
end
