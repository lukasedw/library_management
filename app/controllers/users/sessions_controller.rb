class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    render json: {
      status: {
        success: "Logged in successfully."
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        success: "Logged out successfully."
      }, status: :ok
    else
      render json: {
        error: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
