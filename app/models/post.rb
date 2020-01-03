class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :delete_all
  after_create :set_slug
  validates :body, presence: true, length: { minimum: 10, maximum: 1500 }

  default_scope -> { order(updated_at: :desc) }

  def to_param
    slug
  end

  def like_post

  end

  def unlike_post

  end

  private

  def set_slug
    self.update(slug: self.body.parameterize.truncate(48, omission: ''))
  end
end
