class Api::V1::PicturesController < ApplicationController
  before_action :authenticate_request
  before_action :set_picture, only: %i[destroy]

  # GET /api/v1/pictures
  def index
    _, pictures = pagy(current_user.pictures.includes([:likes, :theme]).order(created_at: :desc))
    expires_in 1.hour, public: true
    render json: {
      pictures: PictureSerializer.new(pictures, include: [:user, :theme, :likes]).serializable_hash,
      # pagy: pagy_metadata(pagy)
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

  # DELETE /api/v1/pictures/:id
  def destroy
    authorize @picture
    @picture.soft_destroy
    render json: { message: "Picture was successfully deleted" }, status: :ok
  rescue => e
    render json: { error: "Failed to delete picture: #{e.message}" }, status: :internal_server_error
  end

  private

    def set_picture
      @picture = current_user.pictures.find_by(uid: params[:id])
    end

    def picture_params
      params.require(:picture).permit(:image_url, :frame_id)
    end
end
