require "pagy/extras/metadata"

class Api::V1::PicturesController < ApplicationController
  skip_before_action :authenticate_request, only: %i[top]
  before_action :set_picture, only: %i[update switch_frame destroy]

  # GET /api/v1/pictures
  def index
    pagy, pictures = pagy(Picture.includes([:likes, :theme, :user]).without_soft_destroyed.order(created_at: :desc))
    render json: {
      pictures: PictureSerializer.new(pictures, include: [:user, :theme, :likes]).serializable_hash,
      pagy: pagy_metadata(pagy),
    }, status: :ok
  end

  # POST /api/v1/pictures
  def create
    theme = Theme.find_or_create_by(title: params[:title])

    if theme.persisted?
      picture = current_user.pictures.build(
        image_url: picture_params[:image_url],
        theme:,
        uid: SecureRandom.uuid
      )

      authorize picture

      if picture.save
        render json: PictureSerializer.new(picture).serializable_hash, status: :created
      else
        render json: { errors: picture.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: theme.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/pictures/:id
  def update
    authorize @picture
    if @picture.update(picture_params)
      render json: @picture, serializer: PictureSerializer, status: :ok
    else
      render json: { error: @picture.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/pictures/:id/switch_frame
  def switch_frame
    authorize @picture, :update?
    if @picture.update(frame_params)
      render json: { message: "Frame switched successfully" }, status: :ok
    else
      render json: { error: @picture.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/pictures/:id
  def destroy
    authorize @picture
    @picture.soft_destroy
    render json: { message: "Picture was successfully deleted" }, status: :ok
  rescue => e
    render json: { error: "Failed to delete picture: #{e.message}" }, status: :internal_server_error
  end

  # GET /api/v1/pictures/top
  def top
    pictures = Picture.includes(:likes, :user, :theme).without_soft_destroyed.order(created_at: :desc).limit(6)
    render json: PictureSerializer.new(pictures, include: [:user, :likes]).serializable_hash, status: :ok
  end

  private

    def set_picture
      @picture = current_user.pictures.find(params[:id])
    end

    def picture_params
      params.require(:picture).permit(:image_url, :frame_id)
    end

    def frame_params
      params.require(:picture).permit(:frame_id)
    end
end
