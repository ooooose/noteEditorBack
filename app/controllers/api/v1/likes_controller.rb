class Api::V1::LikesController < ApplicationController
  # POST /api/v1/likes
  def create
    current_user.like(@picture)
    render json: { message: "Liked the picture" }, status: :ok
  end

  # DELETE /api/v1/likes/:id
  def destroy
    current_user.unlike(@picture)
    render json: { message: "Unliked the picture" }, status: :ok
  end

  private

    def set_picture
      @picture = Picture.find_by(uid: params[:picture_id])
    end
end
