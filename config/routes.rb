# frozen_string_literal: true

Rails.application.routes.draw do
  
  root to: "pages#root"
  get '*path', to: 'pages#root'

end
