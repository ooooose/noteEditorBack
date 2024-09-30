# Table name: likes
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  picture_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
# Indexes
#  index_likes_on_user_id_and_picture_id  (user_id,picture_id) UNIQUE
# Foreign Keys
#  fk_rails_...  (picture_id => pictures.id)
#  fk_rails_...  (user_id => users.id)
# #
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :picture

  validates :user_id, uniqueness: { scope: :picture_id }
end
