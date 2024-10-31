class UserSerializer
  include JSONAPI::Serializer
  set_type :user
  attributes :name, :email, :image, :uid

  has_many :pictures, serializer: PictureSerializer
  has_many :liked_pictures, serializer: PictureSerializer
end
