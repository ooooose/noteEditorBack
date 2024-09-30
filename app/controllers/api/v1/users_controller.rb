class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[create]

  def create
    @current_user = User.find_by(email: user_params[:email])

    if @current_user.nil?
      ActiveRecord::Base.transaction do
        @current_user = User.new(user_params)
        @current_user.uid = SecureRandom.uuid
        @current_user.save!
      end
    end

    encoded_token = JwtService.encode(user_id: @current_user.id)

    render json: { user: @current_user, accessToken: encoded_token, status: :ok }
  rescue => e
    render json: { error: "ログインに失敗しました: #{e.message}" }, status: :internal_server_error
  end

  private

    def user_params
      params.require(:user).permit(:email)
    end
end
