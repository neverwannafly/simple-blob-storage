class RpcSessionController < ApplicationController
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

  def rpc
    options = params[:options].split(' ')
    command = params[:command]

    render json: {
      output: UserSession.execute_remote_command(@session, command, options)
    }
  end

  private

  def set_session_data
    @session = UserSession.allocate_session(user: current_user)
    @server = @session.server
  end
end
