class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  before_action :configure_sign_up_params, only: [:create]

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  private

  def respond_with(current_user, _opts = {})
    if resource.persisted?
      render json: {
        success: "Signed up successfully."
      }
    else
      render json: {
        error: "User couldn't be created successfully.",
        messages: current_user.errors.full_messages.to_sentence
      }, status: :unprocessable_entity
    end
  end
end
