class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  after_create :set_default_avatar

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :friend_requests, foreign_key: :from_user_id, dependent: :destroy
  has_many :friend_requests, foreign_key: :to_user_id
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy, as: :commentable
  has_one_attached :avatar
  validates :username, presence: true, length: { maximum: 30 }

  private

  def set_default_avatar
    self.avatar.attach(
        io: File.open("app/assets/images/empty_avatar.png"),
        filename: "empty_avatar.png",
        content_type: "image/png"
    )
  end
end
