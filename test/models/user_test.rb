require 'test_helper'

class UserTest < ActiveSupport::TestCase
  

# Shoulda gem tests ----------------

  should have_many(:user_friendships)
  should have_many(:friends)


# -----------------------------------

# Tests for validation of fields to be present in app/models/user.rb
  test "a user should enter a first name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:first_name].empty?
  end

  test "a user should enter a last name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:last_name].empty?
  end

  test "a user should enter a profile name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end

# Make sure that the profile name is unique
  test "a user should have a unique profile name" do
  	user = User.new
  	user.profile_name = 'johncoldtrain'
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  	# puts user.errors.inspect
  end

# Format test
  test "a user should have a profile name without spaces" do
  	user = User.new
  	user.profile_name = "My profile with spaces"

  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  	assert user.errors[:profile_name].include?("must be formatted correctly.")
  end

  test "a user can hava a correyctly formatted profile name" do
    user = User.new
    user.profile_name = 'johncoldtrain_1'

    assert !user.save
    assert user.errors[:profile_name].empty?
  end

  # Tests for relationships with friendships -------------------

  test "that no error is raised when trying to access a friend list" do
    assert_nothing_raised do
      users(:alex).friends
    end
  end

  test "that creating friendships on a user works" do
    users(:alex).pending_friends << users(:mike)
    users(:alex).pending_friends.reload
    assert users(:alex).pending_friends.include?(users(:mike))
  end

  test "that calling to_param on a user returns the profile_name" do
    assert_equal "perrogacho", users(:perro).to_param
  end

end
