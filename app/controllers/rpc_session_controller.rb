class RpcSessionController < ApplicationController
  include MessageEncryptor

  before_action :authenticate_user!
  before_action :set_session_data, except: [:index]

  def index
  end

  def session_data
    render json: {
      session: @session,
      user: current_user,
      server: @server,
    }
  end

  def cd
    directory = params[:dir]
    if directory == '..'
      @session.session_datum.update(active_node: @file_system.parent_id)
      head :ok and return
    end

    fs = FileSystem.where(parent_id: @file_system.id, node_name: directory).first
    head :not_found and return if fs.nil?

    @session.session_datum.update(active_node: fs.id)
    head :ok
  end

  def link
    file_name = params[:name]
    fs = FileSystem.where(parent_id: @file_system.id, node_name: file_name).first
    head :not_found and return if fs.nil?

    certificate = encrypt(YAML.dump({ valid_upto: DateTime.now + 60.minutes }))
    link = "files/#{fs.id}?certificate=#{certificate}"

    render json: { link: link }
  end

  def rpc
    options = [
      params[:options].split(' ')[0],
      params[:options]&.split(' ')&.slice(1, params[:options]&.split(' ')&.size)&.join(' ')
    ]
    command = params[:command]

    render json: {
      output: UserSession.execute_remote_command(@session, command, options)
    }
  end

  def upload_file
    command = 'upload'
    name = params[:newFileName]
    if name == ''
      name = params[:file_name]
    end
    options = [
      params[:file].split(',')[-1],
      {
        size: params[:file_size],
        type: params[:file_type],
        name: name
      }
    ]

    render json: {
      output: UserSession.execute_remote_command(@session, command, options)
    }
  end

  private

  def set_session_data
    @session = UserSession.allocate_session(user: current_user)
    @server = @session.server
    @file_system = FileSystem.where(id: @session.session_datum.active_node).first
  end
end
