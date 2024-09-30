# Table name: comments
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  picture_id :bigint           not null
#  body       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
# Indexes
#  index_comments_on_picture_id  (picture_id)
#  index_comments_on_user_id     (user_id)
# Foreign Keys
#  fk_rails_...  (picture_id => pictures.id)
#  fk_rails_...  (user_id => users.id)
# #
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :picture

  validates :body, presence: true, length: { maximum: 200 }
end
