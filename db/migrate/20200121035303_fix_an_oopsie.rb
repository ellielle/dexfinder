class FixAnOopsie < ActiveRecord::Migration[6.0]
  def change
    rename_column :comments, :comment_type, :commentable_type
    add_reference :comments, :user, foreign_key: true
  end
end
