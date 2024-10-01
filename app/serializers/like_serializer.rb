class LikeSerializer
  include JSONAPI::Serializer
  set_type :like
  attributes :id, :user_id, :picture_id

  belongs_to :user, serializer: UserSerializer
  belongs_to :picture, serializer: PictureSerializer
end
