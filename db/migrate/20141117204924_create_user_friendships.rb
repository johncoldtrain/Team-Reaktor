class CreateUserFriendships < ActiveRecord::Migration
  def change
    create_table :user_friendships do |t|

    # Added manually the 2 columns to be included in the table for UserFriendships
      t.integer :user_id 
      t.integer :friend_id

      t.timestamps
    end

    # Also added the indexes necessary for the table to work properly
    add_index :user_friendships, [:user_id, :friend_id]
  end
end
