class ApplicationController < ActionController::API
  include Pundit::Authorization
  include JwtAuthenticatable
  include Pagy::Backend
  before_action :authenticate_request

  def encode_jwt(payload)
    JWT.encode(payload, Rails.application.credentials.secret_key_base, "HS256")
  end

  attr_reader :current_user

  private

    def authenticate_request
      token = request.headers["Authorization"]&.split(" ")&.last
      decoded_token = decode(token)
      if decoded_token
        @current_user = User.find_by(id: decoded_token[:user_id])
      else
        render json: { error: "Not Authorized" }, status: :unauthorized unless @current_user
      end
    end
end
