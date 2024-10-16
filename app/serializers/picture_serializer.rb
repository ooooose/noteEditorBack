class PictureSerializer
  include JSONAPI::Serializer
  set_type :picture
  attributes :id, :image_url, :frame_id, :created_at

  has_many :comments, serializer: CommentSerializer
  belongs_to :user, serializer: UserSerializer
end
