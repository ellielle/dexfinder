class AddIndexToStatus < ActiveRecord::Migration[6.0]
  def change
    add_index :friend_requests, :status
  end
end
