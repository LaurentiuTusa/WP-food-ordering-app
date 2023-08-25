class Api::SessionsController < Api::ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user&.authenticate(params[:session][:password])
      if user.activated?
        reset_session
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        if current_user.admin?

          render json: current_user, serializer: UserSerializer, status: :ok
        else

          render json: current_user, serializer: UserSerializer, status: :ok
        end
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."

        render json: { error: message }, status: :unprocessable_entity
      end
    else

      render json: { error: 'Invalid email/password combination' }, status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
