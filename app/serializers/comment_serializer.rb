class CommentSerializer
  include JSONAPI::Serializer
  attributes :id, :content, :created_at
end
