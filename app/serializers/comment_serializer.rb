class CommentSerializer
  include JSONAPI::Serializer
  attributes :id, :body, :created_at

  belongs_to :user, serializer: UserSerializer
  belongs_to :picture, serializer: PictureSerializer
end
