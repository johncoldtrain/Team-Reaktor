require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
 
	context "#index" do

		context "when not logged in" do
			should "redirect to the login page" do
				get :index
				assert_response :redirect
			end
		end

		context "when logged in" do
			setup do
				@friendship1 = create(:pending_user_friendship, user: users(:alex), friend: create(:user, first_name: 'Pending_friend', last_name: 'Friend'))
				@friendship2 = create(:accepted_user_friendship, user: users(:alex), friend: create(:user, first_name: 'Active_friend', last_name: 'Friend'))
				@friendship3 = create(:requested_user_friendship, user: users(:alex), friend: create(:user, first_name: 'Requested_friend', last_name: 'Friend'))
				@friendship4 = user_friendships(:blocked_by_alex)

				sign_in users(:alex)
				get :index
			end

			should "get the index page without error" do
				assert_response :success
			end

			should "assign user_friendships" do
				assert assigns(:user_friendships)
			end

			should "display friend's names" do
				assert_match /Pending_friend/, response.body
				assert_match /Active_friend/, response.body
			end

			should "display pending information on a pending friendship" do
				assert_select "#user_friendship_#{@friendship1.id}" do  #  <-- assert_select to scope the test through html selectors
					assert_select "em", "Friendship is pending"
				end
			end

			should "display pending information on a accepted friendship" do
				assert_select "#user_friendship_#{@friendship2.id}" do 
					assert_select "em", "Friendship is accepted"
				end
			end


			context "blocked users" do
				setup do
					get :index, list: 'blocked'
				end

				should "get the index without error" do
					assert_response :success
				end

				should "not display pending or active friend's names" do
					assert_no_match /Pending_friend\ Friend/, response.body
					assert_no_match /Active_friend\ Friend/, response.body
				end

				should "display blocked friend names" do 
					assert_match /Blocked_friend\ Friend/, response.body
				end

			end # - blocked users -


			context "pending friendships" do
		        setup do
		          get :index, list: 'pending'
		        end

		        should "get the index without error" do
		          assert_response :success
		        end

		        should "not display pending or active friend's names" do
		          assert_no_match /Blocked_friend/, response.body
		          assert_no_match /Active_friend/, response.body
		        end

		        should "display blocked friends" do
		          assert_match /Pending_friend/, response.body
		        end

		     end # - pending friendships -


			context "requested friendships" do
		        setup do
		          get :index, list: 'requested'
		        end

		        should "get the index without error" do
		          assert_response :success
		        end

		        should "not display pending or active friend's names" do
		          assert_no_match /Blocked_friend/, response.body
		          assert_no_match /Active_friend/, response.body
		        end

		        should "display requested friends" do
		          assert_match /Requested_friend/, response.body
		        end

		     end # - requested friendships -


		      context "accepted friendships" do
		        setup do
		          get :index, list: 'accepted'
		        end

		        should "get the index without error" do
		          assert_response :success
		        end

		        should "not display pending or active friend's names" do
		          assert_no_match /Blocked_friend/, response.body
		          assert_no_match /Requested_friend/, response.body
		        end

		        should "display requested friends" do
		          assert_match /Active_friend/, response.body
		        end

		    end # - accepted friendships -


		end # when logged in
	end # ---- #index ----



	context "#new" do

		context "when not logged in" do
			should "redirect to the login page" do
				get :new
				assert_response :redirect
			end
		end

		context "when logged in" do
			setup do
				sign_in users(:alex)
			end

			should "get new and return success" do
				get :new
				assert_response :success
			end

			should "should set a flash error if the friend_id params is missing" do
				get :new, {}
				assert_equal "Friend required", flash[:alert]
			end

			should "display the friend's name" do
				get :new, friend_id: users(:perro)
				assert_match /#{users(:perro).full_name}/, response.body
			end

			should "assign a new user friendship" do
				get :new, friend_id: users(:perro)
				assert assigns(:user_friendship)
			end

			should "assign the correct user as a friend" do
				get :new, friend_id: users(:perro)
				assert_equal users(:perro), assigns(:user_friendship).friend
			end

			should "assign a new user friendship to the currently logged user" do
				get :new, friend_id: users(:perro)
				assert_equal users(:alex), assigns(:user_friendship).user
			end

			should "return a 404 status if no friend is found" do
				get :new, friend_id: 'invalid'
				assert_response :not_found
			end

			should "ask if you really want to request this friendship" do
				get :new, friend_id: users(:perro)
				assert_match /Do you really want to friend #{users(:perro).full_name}?/, response.body
			end

		end # When Logged In

	end # ---- #new ----

	context "#create" do
		context "when not logged in" do

			should "redirect to the login page" do
				get :new
				assert_response :redirect
				assert_redirected_to login_path
			end

		end

		context "when logged in" do

			setup do
				sign_in users(:alex)
			end

			context "with no friend_id" do
				setup do
					post :create
				end

				should "set the flash error message" do
					assert !flash[:alert].empty?
				end

				should "be redirected to the site root" do
					assert_redirected_to root_path
				end

			end #with no friend_id

			context "successfully" do

				should "create two user friendship objects" do
					assert_difference 'UserFriendship.count', 2 do
						post :create, user_friendship: { friend_id: users(:mike).profile_name }
					end
				end

			end


			context "with a valid friend_id" do

				setup do
					post :create, user_friendship: { friend_id: users(:perro) }
				end

				should "assign a friend object" do
					assert assigns(:friend)
				end

				should "assign a user friendship object" do
					assert assigns(:user_friendship)
					assert_equal users(:alex), assigns(:user_friendship).user
					assert_equal users(:perro), assigns(:user_friendship).friend
				end

				should "create a friendship" do
					assert users(:alex).pending_friends.include?(users(:perro))
				end

				should "redirect to the profile page of the friend" do
					assert_response :redirect
					assert_redirected_to profile_path(users(:perro))
				end

				should "set the flash success message" do
					assert flash[:notice]
					assert_equal "Friend request sent.", flash[:notice]
				end

			
			end #with a valid friend_id

		end # When logged in

	end # ---- #create ----


	context "#accept" do 

		context "when not logged in" do
			should "redirect to the login page" do
				put :accept, id: 1
				assert_response :redirect
			end
		end

		context "when logged in" do
			setup do
				@friend = create(:user)
				@user_friendship = create(:pending_user_friendship, friend: @friend, user: users(:alex))
				create(:requested_user_friendship, friend: users(:alex), user: @friend)

				sign_in users(:alex)
				put :accept, id: @user_friendship
				@user_friendship.reload
			end

			should "assign a user_friendship" do
				assert assigns(:user_friendship)
				assert_equal @user_friendship, assigns(:user_friendship)
			end

			should "update the state to accepted" do
				assert_equal 'accepted', @user_friendship.state
			end

			should "have a flash success message" do
				assert_equal "You are now friends with #{@user_friendship.friend.first_name}", flash[:notice]
			end

		end # -- when logged in --

	end # ---- #accept ----


	context "#edit" do

		context "when not logged in" do
			should "redirect to the login page" do
				get :edit, id: 1
				assert_response :redirect
			end
		end

		context "when logged in" do
			setup do
				@user_friendship = create(:pending_user_friendship, user: users(:alex))
				sign_in users(:alex)
				get :edit, id: @user_friendship.friend.profile_name
			end

			should "get edit and return success" do
				assert_response :success
			end

			should "assign to user_friendship" do
				assert assigns(:user_friendship)
			end

			should "assign to friend" do
				assert assigns(:friend)
			end

		end # -- when logged in --

	end # ---- #edit ----



	context "#destroy" do 

		context "when not logged in" do
			should "redirect to the login page" do
				put :accept, id: 1
				assert_response :redirect
			end
		end

		context "when logged in" do
			setup do
				@friend = create(:user)
				@user_friendship = create(:accepted_user_friendship, friend: @friend, user: users(:alex))
				create(:accepted_user_friendship, friend: users(:alex), user: @friend)

				sign_in users(:alex)
				
			end

			should "delete user friendships" do
				assert_difference 'UserFriendship.count', -2 do
					delete :destroy, id: @user_friendship
				end
			end

			should "set the flash" do
				delete :destroy, id: @user_friendship
				assert_equal "Friendship destroyed", flash[:notice]
			end

		end # -- when logged in --

	end # ---- #destroy ----


	context "#block" do
		context "when not logged in" do
			should "redirect to the login page" do
				put :block, id: 1
				assert_response :redirect
				assert_redirected_to login_path
			end
		end

		context "when logged in" do
			setup do
				@user_friendship = create(:pending_user_friendship, user: users(:alex))
				sign_in users(:alex)
				put :block, id: @user_friendship
				@user_friendship.reload
			end

			should "assign a user friendship" do
				assert assigns(:user_friendship)
				assert_equal @user_friendship, assigns(:user_friendship)
			end

			should "update the user friendship stat to blocked" do
				assert_equal 'blocked', @user_friendship.state
			end

		end # - when logged in -

	end # ---- #block ----



end


































