class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[discord]

  has_many :outgoing_friend_requests, class_name: "FriendRequest", foreign_key: :from_user_id, dependent: :destroy
  has_many :incoming_friend_requests, class_name: "FriendRequest", foreign_key: :to_user_id
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy, as: :commentable
  has_one_attached :avatar
  validates :username, presence: true, length: { maximum: 30 }
  validates :avatar, content_type: ['image/jpg', 'image/png', 'image/jpeg'],
            size: { less_than: 2.megabytes, message: 'is too large'}

  def member_since
    self.created_at.strftime("%b. %Y")
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.username = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.avatar.attach(io: URI.open(auth.info.image),
                         filename: File.basename(URI.parse(auth.info.image).path)) if auth.info.image
    end
  end
end
