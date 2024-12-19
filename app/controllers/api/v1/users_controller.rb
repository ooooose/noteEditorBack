require "pagy/extras/metadata"

class Api::V1::UsersController < ApplicationController
  include JwtAuthenticatable
  skip_before_action :authenticate_request, only: %i[create top]
  before_action :set_user, only: %i[pictures liked_pictures]

  # GET /api/v1/users/profile
  def me
    render json: UserSerializer.new(current_user).serializable_hash, status: :ok
  end

  # PATCH /api/v1/users/profile
  def update_profile
    current_user.update!(user_params)
    render json: UserSerializer.new(current_user).serializable_hash, status: :ok
  rescue => e
    render json: { error: "プロフィールの更新に失敗しました: #{e.message}" }, status: :internal_server_error
  end

  # POST /api/v1/users
  def create
    @current_user = User.without_soft_destroyed.find_by(email: user_params[:email])

    if @current_user.nil?
      @current_user = User.new(user_params)
      @current_user.uid = SecureRandom.uuid
      @current_user.save!
    end

    encoded_token = encode(user_id: @current_user.id)

    render json: { user: @current_user, accessToken: encoded_token, status: :ok }
  rescue => e
    render json: { error: "ログインに失敗しました: #{e.message}" }, status: :internal_server_error
  end

  # GET /api/v1/users/:uid
  def show
    render json: UserSerializer.new(current_user).serializable_hash.to_json, status: :ok
  end

  # GET /api/v1/users/:uid/pictures
  def pictures
    pagy, pictures = pagy(@user.pictures.includes([:likes, :theme]).order(created_at: :desc))
    render json: {
      pictures: PictureSerializer.new(pictures, include: [:user, :theme, :likes]).serializable_hash,
      pagy: pagy_metadata(pagy),
    }, status: :ok
  end

  # GET /api/v1/users/:uid/liked_pictures
  def liked_pictures
    pagy, pictures = pagy(@user.liked_pictures.includes([:likes, :theme, :user]).order(created_at: :desc))
    render json: {
      pictures: PictureSerializer.new(pictures, include: [:user, :theme, :likes]).serializable_hash,
      pagy: pagy_metadata(pagy),
    }, status: :ok
  end

  # DELETE /api/v1/users/:uid
  def destroy
    current_user.soft_destroy!
    render json: { message: "ユーザーを削除しました" }, status: :ok
  rescue => e
    render json: { error: "ユーザーの削除に失敗しました: #{e.message}" }, status: :internal_server_error
  end

  # GET /api/v1/users/top
  def top
    top_users = User.joins(:pictures)
                    .select('users.*, COUNT(pictures.id) AS total_pictures_count')
                    .group('users.id')
                    .order('total_pictures_count DESC')
                    .limit(3)

    render json: UserSerializer.new(top_users).serializable_hash, status: :ok
  rescue => e
    render json: { error: "データの取得に失敗しました: #{e.message}" }, status: :internal_server_error
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :image)
    end

    def set_user
      @user = User.find_by(uid: params[:uid])
    end
end
