class Api::V1::LikesController < ApplicationController
  before_action :authenticate_request
  before_action :set_picture, only: %i[create destroy]

  # POST /api/v1/likes
  def create
    if @picture.nil?
      render json: { error: "Picture not found" }, status: :not_found
    elsif current_user.like(@picture)
      render json: { message: "Liked the picture" }, status: :ok
    else
      render json: { error: "Failed to like the picture" }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/likes/:id
  def destroy
    if @picture.nil?
      render json: { error: "Picture not found" }, status: :not_found
    elsif current_user.unlike(@picture)
      render json: { message: "Unliked the picture" }, status: :ok
    else
      render json: { error: "Failed to unlike the picture" }, status: :unprocessable_entity
    end
  end

  private

    def set_picture
      @picture = Picture.find_by(uid: params[:picture_uid])
    end
end
