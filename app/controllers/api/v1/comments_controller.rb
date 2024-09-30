class Api::V1::CommentsController < ApplicationController
  def index
    picture = Picture.find(params[:picture_id])
    @comments = picture.comments

    render json: @comments, each_serializer: CommentSerializer
  end
end