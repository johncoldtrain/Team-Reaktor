require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

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
  	puts user.errors.inspect
  end

# Format test
  test "a user should have a profile name without spaces" do
  	user = User.new
  	user.profile_name = "My profile with spaces"

  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  	assert user.errors[:profile_name].include?("must be formatted correctly.")
  end


end
