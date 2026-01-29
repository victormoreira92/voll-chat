class ApplicationController < ActionController::API
  before_action :authenticate

  rescue_from JWT::VerificationError, with: :invalid_token
  rescue_from JWT::DecodeError, with: :decode_error

  private

  def authenticate
    authorization_header = request.headers["Authorization"]
    token = authorization_header.split(" ").last if authorization_header
    decoded_token = JsonTokenWeb.decode(token)

    @current_user = User.find(decoded_token["user_id"])
  end

  def invalid_token
    render_response({ message: I18n.t("errors.unauthorized"), code: 401 })
  end

  def decode_error
    render_response({ message: I18n.t("errors.invalid_token"), code: 401 })
  end

  def render_response(response)
    if response.is_a?(Hash) && response[:message]
      render json: { error: response[:message] }, status: response[:code]
    else
      render json: response
    end
  end
end
