class Api::ApplicationController < ActionController::API
  include ActiveStorage::SetCurrent
  include ActionController::HttpAuthentication::Token

  def current_authorized_user
    @current_user ||= compute_current_user
  end

  private

  def compute_current_user
    token, _options = token_and_options(request)
    user_id = AuthenticationTokenService.decode(token)

    User.find(user_id)
  rescue ActiveRecord::RecordNotFound
    head :unauthorized
  end

  def authenticate_user!
    render json: { error: 'You need to log in to add products to the cart' }, status: :unauthorized if current_authorized_user.nil?
  end
end
