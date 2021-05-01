Rails.application.routes.draw do
  root 'home#index'

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/', to: 'home#index', as: :home_controller
  post '/generate_token', to: 'home#generate_token'
end
