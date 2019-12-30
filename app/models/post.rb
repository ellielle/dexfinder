class Post < ApplicationRecord
  belongs_to :user
  after_create :set_slug
  validates :body, presence: true, length: { minimum: 10, maximum: 1500 }

  default_scope -> { order(created_at: :desc) }

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
