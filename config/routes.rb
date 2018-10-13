# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#index'

  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?

  get '*path', to: 'pages#index'
  post '/graphql', to: 'graphql#execute'
end
