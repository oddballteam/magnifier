# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  before_action :current_user
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  def test
    current_user
  	render 'layouts/application'
  end
  def me
      render json: @current_user
  end
end
