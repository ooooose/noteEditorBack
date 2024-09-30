class UserSerializer
  include JSONAPI::Serializer
  set_type :user
  attributes :name, :email, :image
  
  has_many :pictures, serializer: PictureSerializer
end