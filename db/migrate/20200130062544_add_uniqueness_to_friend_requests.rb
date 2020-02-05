class AddUniquenessToFriendRequests < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        connection.execute(%q(
                    create unique index index_friend_requests_on_interchangeable_from_user_id_and_to_user_id on friend_requests(greatest(from_user_id,to_user_id), least(from_user_id,to_user_id));
                    create unique index index_friend_requests_on_interchangeable_to_user_id_and_from_user_id on friend_requests(least(from_user_id,to_user_id), greatest(from_user_id,to_user_id));
                ))
      end

      dir.down do
        connection.execute(%q(
                    drop index index_friend_requests_on_interchangeable_from_user_id_and_to_user_id;
                    drop index index_friend_requests_on_interchangeable_to_user_id_and_from_user_id;
                ))
      end
    end
  end
end