class AddUniquenessToFriendRequests < ActiveRecord::Migration[6.0]
  def change
    remove_index :friend_requests, name: "index_friend_requests_on_from_user_id"
    remove_index :friend_requests, name: "index_friend_requests_on_to_user_id"
    add_index :friend_requests, [:to_user_id, :from_user_id], unique: true
  end
end
