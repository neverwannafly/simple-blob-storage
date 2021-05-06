class RpcSessionController < ApplicationController
  before_action :set_session_data, except: [:index]

  def index
  end

  def session_data
    head :not_found and return if @session.nil?

    render json: {
      session: @session,
      user: @session.user,
      server: @session.server,
    }
  end

  private

  def set_session_data
    @session = UserSession.allocate_session(user: current_user)
  end
end
