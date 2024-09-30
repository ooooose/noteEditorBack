class Api::V1::CommentsController < ApplicationController
  picture = Picture.find(params[:picture_id])
  @comments = picture.comments

  render json: @comments, each_serializer: CommentSerializer
end
