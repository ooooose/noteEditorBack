class Api::V1::LikesController < ApplicationController

  # POST /api/v1/likes
  def create
    current_user.likes.create!(picture_id: params[:picture_id])
  end
end
