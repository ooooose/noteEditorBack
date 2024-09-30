module JwtAuthenticatable
  extend ActiveSupport::Concern

  SECRET_KEY = Rails.application.credentials.secret_key_base

  class_methods do
    def encode(payload)
      JWT.encode(payload, SECRET_KEY, "HS256")
    end

    def decode(token)
      decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: "HS256" })[0]
      HashWithIndifferentAccess.new decoded
    rescue JWT::DecodeError => e
      Rails.logger.error "JWT decode error: #{e.message}"
      nil
    end
  end
end
