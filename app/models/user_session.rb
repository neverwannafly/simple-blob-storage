class UserSession < ApplicationRecord
  extend RpcRequestHandlerHelper

  belongs_to :user
  belongs_to :server
  belongs_to :auth_token
  has_one :session_datum

  enum state: [:ongoing, :ended]

  def current_directory
    self.session_data.active_node
  end

  def self.allocate_session(user:, auth_token: nil)
    if auth_token.nil?
      auth_token = AuthToken.where(bearer: user).order("scope desc").first
    end
    return nil if auth_token.nil?

    # Find an existing session
    session = self.ongoing.where(user_id: user.id, auth_token_id: auth_token.id).first
    if session.nil?
      session = init_connection({ user_id: user.id, auth_token_id: auth_token.id, username: user.username })
      return nil if session.nil?
    end

    return session
  end

  def self.execute_remote_command(session, command, params = nil)
    url = "#{session.server.url}/RPC2"
    user_id = session.user.id
    base_prefix = FileSystem.find(session.session_datum.active_node).get_node_address

    case command
    when 'ping'
      rpc(url, command)
    when 'ls'
      rpc(url, command, [
        [[
          ["client_id", user_id, "int"],
          ["base_prefix", base_prefix,]
        ], "struct"]
      ])
    when 'pwd'
      rpc(url, command, [
        [[
          ["client_id", user_id, "int"],
          ["base_prefix", base_prefix,]
        ], "struct"]
      ])
    when 'mkdir'
      FileSystem.create_directory(
        parent_id: session.session_datum.active_node, 
        owner_id: session.user_id,
        directory_name: params[0],
      )
      rpc(url, command, [
        [[
          ["client_id", user_id, "int"],
          ["c1", params[0] || '', "string"],
          ["base_prefix", base_prefix,],
        ], "struct"]
      ])
    when 'touch'
      FileSystem.create_file(
        parent_id: session.session_datum.active_node, 
        owner_id: session.user_id,
        file_name: params[0].split('.').slice(0, params[0].split('.').size - 1).join('.'),
        file_size: params[1].bytesize * 8,
        file_type: params[0].split('.')[-1],
      )

      rpc(url, command, [
        [[
          ["client_id", user_id, "int"],
          ["c1", params[0] || '', "string"],
          ["c2", params[1] || ''],
          ["base_prefix", base_prefix,],
        ], "struct"]
      ])
    when 'cp'
      rpc(url, command, [
        [[
          ["client_id", user_id, "int"],
          ["c1", params[0] || '', "string"],
          ["base_prefix", base_prefix,],
          ["c2", params[1] || '']
        ], "struct"]
      ])
    when 'cat'
      rpc(url, command, [
        [[
          ["client_id", user_id, "int"],
          ["c1", params[0] || '', "string"],
          ["base_prefix", base_prefix,],
        ], "struct"]
      ])
    when 'upload'
      name = params[1][:name]
      type = params[1][:type]
      size = params[1][:size]

      FileSystem.create_file(
        parent_id: session.session_datum.active_node, 
        owner_id: session.user_id,
        file_name: name,
        file_size: size,
        file_type: type,
      )
  
      rpc(url, command, [
        [[
          ["client_id", user_id, "int"],
          ["base_prefix", base_prefix,],
          ["file", params[0]],
          ["name", name],
          ["type", type],
          ["size", size],
        ], "struct"]
      ])
    end
  end
end
