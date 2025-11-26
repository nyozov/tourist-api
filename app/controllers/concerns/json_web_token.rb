module JsonWebToken
  SECRET_KEY = Rails.application.credentials.secret_key_base

  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def decode_token
    auth_header = request.headers["Authorization"]
    return nil unless auth_header

    token = auth_header.split(" ")[1]
    JWT.decode(token, SECRET_KEY, true)[0]
  rescue
    nil
  end

  def current_user
    decoded = decode_token
    @current_user ||= User.find_by(id: decoded["user_id"]) if decoded
  end
end
