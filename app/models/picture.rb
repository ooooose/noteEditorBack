# Table name: pictures
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  theme_id   :bigint           not null
#  uid        :string           not null
#  image_url  :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
# Indexes
#  unique_picture_uid           (uid) UNIQUE
#  index_pictures_on_created_at  (created_at)
#  index_pictures_on_user_id_and_theme_id  (user_id,theme_id) UNIQUE
# Foreign Keys
#  fk_rails_...  (theme_id => themes.id)
#  fk_rails_...  (user_id => users.id)
# #
class Picture < ApplicationRecord
  belongs_to :user
  belongs_to :theme
  has_many :likes, inverse_of: :picture, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_many :comments, inverse_of: :picture, dependent: :destroy

  validates :image_url, presence: true
  validates :frame_id, presence: true
  validates :uid, presence: true, uniqueness: true

  def soft_destroy
    update!(deleted_at: Time.current)
  end
end
