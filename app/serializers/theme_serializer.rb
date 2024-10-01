class ThemeSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :created_at
end
