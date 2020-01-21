class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :friend_requests, foreign_key: :from_user_id, dependent: :delete_all
  has_many :friend_requests, foreign_key: :to_user_id
  has_many :posts, dependent: :delete_all
  has_many :likes, dependent: :delete_all
  has_many :comments, dependent: :delete_all, as: :commentable
  validates :username, presence: true, length: { maximum: 30 }
end
