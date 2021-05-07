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

  def ping
    render json: {
      output: UserSession.execute_remote_command(@session, :ping)
    }
  end

  def ls
    render json: {
      output: UserSession.execute_remote_command(@session, :ls)
    }
  end

  private

  def set_session_data
    @session = UserSession.allocate_session(user: current_user)
    @server = @session.server
  end
end
