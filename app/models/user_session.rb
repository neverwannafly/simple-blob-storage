class UserSession < ApplicationRecord
  extend RpcRequestHandlerHelper

  belongs_to :user
  belongs_to :server
  belongs_to :auth_token

  enum state: [:ongoing, :ended]

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

  def self.execute_remote_command(session, command, params = nil)
    url = "#{session.server.url}/RPC2"
    user_id = session.user.id

    case command
    when 'ping'
      rpc(url, command)
    when 'ls'
      rpc(url, command, [
        [[["client_id", user_id, "int"]], "struct"]
      ])
    when 'pwd'
      rpc(url, command, [
        [[["client_id", user_id, "int"]], "struct"]
      ])
    when 'touch'
      rpc(url, command, [
        [[
          ["client_id", user_id, "int"],
          ["c1", params[0] || '', "string"],
          ["c2", params[1] || '']
        ], "struct"]
      ])
    when 'cp'
      rpc(url, command, [
        [[
          ["client_id", user_id, "int"],
          ["c1", params[0] || '', "string"],
          ["c2", params[1] || '']
        ], "struct"]
      ])
    when 'cat'
      rpc(url, command, [
        [[
          ["client_id", user_id, "int"],
          ["c1", params[0] || '', "string"],
        ], "struct"]
      ])
    end
  end
end
