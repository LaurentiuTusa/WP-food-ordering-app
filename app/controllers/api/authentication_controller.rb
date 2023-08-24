class Api::AuthenticationController < Api::ApplicationController
  class AuthenticationError < StandardError; end

  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from AuthenticationError, with: :handle_unauthenticated

  before_action :current_user, only: [:logout]

  def create
    raise AuthenticationError unless user.authenticate(params.require(:password))

    token = AuthenticationTokenService.encode(user.id)
    render json: { token: token }, status: :created
  end

  def login
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      token = AuthenticationTokenService.encode(user.id)

      render json: {token: token }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def logout
    head :no_content
  end

  private

  def user
    @user ||= User.find_by(email: params.require(:email))
  end

  def parameter_missing(e)
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def handle_unauthenticated
    head :unauthorized
  end
end
