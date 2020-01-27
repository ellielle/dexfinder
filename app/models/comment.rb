class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  has_many :comments, dependent: :destroy, as: :commentable
  validates :body, presence: true, length: { maximum: 1000 }
  validates :user_id, presence: true

  default_scope -> { order(updated_at: :desc) }

  def user
    User.find(self.user_id)
  end
end
