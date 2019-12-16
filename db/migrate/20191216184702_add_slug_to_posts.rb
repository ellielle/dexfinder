class AddSlugToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :slug, :string, limit: 80
  end
end
