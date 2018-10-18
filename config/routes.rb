# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#index'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :sessions, only: [:create, :destroy]
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?

  get '*path', to: 'pages#index'
  post '/graphql', to: 'graphql#execute'
end
