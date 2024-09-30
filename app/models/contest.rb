# Table name: contests
#  id          :bigint           not null, primary key
#  title       :string           not null
#  description :text             not null
#  start_date  :datetime         not null
#  end_date    :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
# Indexes
#  unique_contest_title  (title) UNIQUE
#  index_contests_on_created_at  (created_at)
# #
class Contest < ApplicationRecord
end
