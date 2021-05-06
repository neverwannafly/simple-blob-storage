class UserSession < ApplicationRecord
  extend RpcRequestHandlerHelper

  belongs_to :user
  belongs_to :server
  belongs_to :auth_key

  enum state: [:ongoing, :ended ]

  def self.allocate_session(user:, auth_token: nil)
    if auth_token.nil?
      auth_token = AuthToken.where(bearer: user).order("scope desc").first
    end
    return nil if auth_token.nil?

    # Find an existing session
    session = self.ongoing.where(user_id: user.id, auth_token_id: auth_token.id).first
    if session.nil?
      session = init_connection({ user_id: user.id, auth_token_id: auth_token.id })
      return nil if session.nil?
    end

    return session
  end
end
