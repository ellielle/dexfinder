class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.text :body
      t.integer :likes, default: 0
      t.references :user

      t.timestamps
    end
  end
end
