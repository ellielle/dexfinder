class RemoveIndexFromComments < ActiveRecord::Migration[6.0]
  def change
    remove_index :comments, [:user_id, :post_id]
  end
end
