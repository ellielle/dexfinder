class FixAnOopsie < ActiveRecord::Migration[6.0]
  def change
    rename_column :comments, :comment_type, :commentable_type
  end
end
