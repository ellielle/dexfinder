class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :comments, dependent: :delete_all
  validates :body, presence: true, length: { maximum: 1000 }

  default_scope -> { order(updated_at: :desc) }
end
