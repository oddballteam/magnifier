# frozen_string_literal: true

Rails.application.routes.draw do
  
  root to: "pages#index"
  get '*path', to: 'pages#index'

end
