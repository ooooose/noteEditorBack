# Table name: users
#  id         :bigint           not null, primary key
#  name       :string(40)       not null
#  uid        :string           not null
#  email      :string           not null
#  image      :string
#  role       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
# Indexes
#  unique_user_emails  (email) UNIQUE
#  unique_user_uid     (uid) UNIQUE
# Foreign Keys
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (theme_id => themes.id)
#
class User < ApplicationRecord
  # Association Layer
  has_many :pictures, dependent: :destroy
  has_many :likes, inverse_of: :user, dependent: :destroy
  has_many :liked_pictures, through: :likes, source: :picture
  has_many :comments, inverse_of: :user, dependent: :destroy
  has_many :commented_pictures, through: :comments, source: :picture

  # Constants Layer
  enum role: { general: 1, admin: 9 }

  # Validation Layer
  validates :name, presence: true, length: { maximum: 40 }
  validates :uid, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true

  # Scope Layer
  scope :without_soft_destroyed, -> { where(deleted_at: nil) }

  # Class Method Layer
  def self.find_with_jwt(encoded_token)
    Rails.logger.debug "Encoded token: #{encoded_token}"
    decoded_token = JWT.decode(encoded_token, Rails.application.credentials.secret_key_base, true,
                               { algorithm: "HS256" })
    payload = decoded_token.first
    Rails.logger.debug "Decoded token payload: #{payload}"
    find(payload["user_id"])
  rescue JWT::DecodeError => e
    Rails.logger.error "JWT decode error: #{e.message}"
    nil
  rescue JWT::ExpiredSignature
    Rails.logger.error "JWT token has expired"
    nil
  rescue JWT::VerificationError
    Rails.logger.error "JWT verification error"
    nil
  end

  # Instance Method Layer
  def soft_destroy!
    update!(deleted_at: Time.current)
  end

  def like(picture)
    liked_pictures << picture
  end

  def unlike(picture)
    liked_pictures.destroy(picture)
  end

  def liked?(picture)
    picture.like_users.include?(self)
  end
end
