class AddIndexToSlugs < ActiveRecord::Migration[6.0]
  def change
    add_index :posts, :slug
  end
end
