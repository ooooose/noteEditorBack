# Table name: themes
#  id         :bigint           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
# Indexes
#  unique_theme_title  (title) UNIQUE
# Foreign Keys
#  fk_rails_...  (theme_id => themes.id)
# #
#
class Theme < ApplicationRecord
  has_many :pictures, -> { order(created_at: :desc) }, inverse_of: :theme, dependent: :destroy

  validates :title, presence: true, uniqueness: { case_sensitive: false }
end
