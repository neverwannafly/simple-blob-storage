class HomeController < ApplicationController
  include MessageEncryptor
  
  before_action :authenticate_user!

  def index
    @auth_tokens = AuthToken.get_tokens_for_bearer(current_user)
    @auth_token = AuthToken.new
    @scopes = AuthToken.scopes.keys
  end

  def reveal_token
    name = params[:token_name]
    scope = params[:token_scope]

    token = AuthToken.get_decrypted_token(current_user, scope, name)
    head :not_found and return if token.nil?
  
    render json: { token: token }
  end

  def generate_token
    random_token = random_string
    scope = params[:auth_token][:scope]
    name = params[:auth_token][:name]

    head :ok and return if AuthToken.is_present?(
      current_user, scope, name
    )

    auth_token = AuthToken.create({
      name: name,
      scope: scope,
      status: :active,
      bearer: current_user,
      token: encrypt(random_token)
    })

    redirect_to :home_controller
  end
end
