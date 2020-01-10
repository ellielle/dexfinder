class AddIndexToComments < ActiveRecord::Migration[6.0]
  def change
    add_index :comments, [:user_id, :post_id], unique: true
  end
end
