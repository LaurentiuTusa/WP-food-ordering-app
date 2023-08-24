class Api::ApplicationController < ActionController::API
  include ActiveStorage::SetCurrent
  include ActionController::HttpAuthentication::Token

  def current_user
    token, _options = token_and_options(request)
    user_id = AuthenticationTokenService.decode(token)

    User.find(user_id)
  rescue ActiveRecord::RecordNotFound
    head :unauthorized
  end
end
