class Api::V1::PicturesController < ApplicationController
  before_action :set_picture, only: %i[destroy]

  # GET /api/v1/pictures
  def index
    current_user.pictures.includes(:users, :theme, :likes, :comments).order(created_at: :desc)
    render json: pictures, each_serializer: PictureSerializer, status: :ok
  end

  # POST /api/v1/pictures
  def create
    picture = current_user.pictures.build(picture_params)
    authorize picture
    if picture.save
      render json: picture, status: :created
    else
      render json: { error: picture.errors.full_messages.join(", ") }, status: :unprocessable_entity
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
      @picture = Picture.find_by(uid: params[:id])
    end

    def picture_params
      params.require(:picture).permit(:image, :theme_id)
    end
end
