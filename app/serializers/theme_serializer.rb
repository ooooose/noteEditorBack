class ThemeSerializer
  include JSONAPI::Serializer
  set_type :theme
  attributes :id, :title, :created_at

  has_many :pictures, serializer: PictureSerializer
end
