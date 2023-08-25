class Api::AccountActivationsController < Api::ApplicationController
  def edit
    user = User.find_by(email: params[:email]) #use activatin token instead of email
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      render json: { success: 'Account activated' }, status: :ok
    else
      render json: { error: 'Invalid activation link' }, status: :unprocessable_entity
    end
  end
end
