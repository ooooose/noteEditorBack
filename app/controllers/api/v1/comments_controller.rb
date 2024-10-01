class Api::V1::CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]

  # GET /api/v1/comments
  def index
    picture = Picture.find(params[:picture_id])
    @comments = picture.comments

    render json: @comments, each_serializer: CommentSerializer
  end

  # POST /api/v1/comments
  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      render json: @comment, status: :created
    else
      render json: { error: @comment.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/comments/:id
  def destroy
    @comment.destroy!
    render json: { message: "Comment was successfully deleted" }, status: :ok
  rescue => e
    render json: { error: "Failed to delete comment: #{e.message}" }, status: :internal_server_error
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :picture_id)
  end
end
