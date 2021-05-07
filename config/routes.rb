Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: { registrations: 'users/registrations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/', to: 'home#index', as: :home_controller
  post '/reveal-token', to: 'home#reveal_token'
  post '/generate-token', to: 'home#generate_token'

  get '/session', to: 'rpc_session#index', as: :session_controller
  get '/session-data', to: 'rpc_session#session_data'

  # RPC commands
  post '/session/rpc', to: 'rpc_session#rpc'
end
