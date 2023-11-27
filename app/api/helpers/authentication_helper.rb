module Helpers::AuthenticationHelper
  def current_user
    @current_user ||= decode_user_from_token
  rescue JWT::DecodeError, JWT::ExpiredSignature => _e
    unauthorized_error!
  end

  private

  def decode_user_from_token
    return nil unless token

    decoder = Warden::JWTAuth::UserDecoder.new
    decoder.call(token, :user, nil)
  end

  def token
    auth = headers["authorization"].to_s
    auth.split(" ")[1]
  end

  def unauthorized_error!
    error!("Access denied.", 401)
  end

  def authenticate!
    unauthorized_error! unless current_user
  end
end
