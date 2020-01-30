class AddUniquenessToFriendRequests < ActiveRecord::Migration[6.0]
  def change
    add_index :friend_requests, [:from_user_id, :to_user_id], unique: true
  end
end
