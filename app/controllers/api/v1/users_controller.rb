class Api::V1::UsersController < ApplicationController
  include JwtAuthenticatable
  skip_before_action :authenticate_request, only: %i[create]

  # POST /api/v1/users
  def create
    @current_user = User.find_by(email: user_params[:email])

    if @current_user.nil?
      ActiveRecord::Base.transaction do
        @current_user = User.new(user_params)
        @current_user.uid = SecureRandom.uuid
        @current_user.save!
      end
    end

    encoded_token = encode(user_id: @current_user.id)

    render json: { user: @current_user, accessToken: encoded_token, status: :ok }
  rescue => e
    render json: { error: "ログインに失敗しました: #{e.message}" }, status: :internal_server_error
  end

  # GET /api/v1/users/:id
  def show
    render json: @current_user, status: :ok
  end

  # DELETE /api/v1/users/:id
  def destroy
    @current_user.soft_destroy
    render json: { message: "ユーザーを削除しました" }, status: :ok
  rescue => e
    render json: { error: "ユーザーの削除に失敗しました: #{e.message}" }, status: :internal_server_error
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email)
    end
end
