class Post < ApplicationRecord
  belongs_to :user
  after_validation :set_slug
  validates :body, presence: true, length: { maximum: 1500 }

  default_scope -> { order(created_at: :desc) }

  def to_param
    slug
  end

  private

  def set_slug
    self.update(slug: self.body.parameterize.truncate(80))
  end
end
