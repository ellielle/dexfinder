class ChangeCommentSchema < ActiveRecord::Migration[6.0]
  def change
    remove_columns :comments, :user_id, :post_id
    add_column :comments, :commentable_id, :integer
    add_column :comments, :commentable_type, :string
    add_index :comments, :commentable_id
  end
end
