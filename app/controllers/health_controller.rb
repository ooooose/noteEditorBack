class HealthController < ApplicationController
  skip_before_action :authenticate_request, only: %i[index]

  def index
    render json: { status: "ok", message: "Application is running smoothly" }, status: :ok
  end
end