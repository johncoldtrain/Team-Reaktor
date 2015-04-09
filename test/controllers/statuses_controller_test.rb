require 'test_helper'

class StatusesControllerTest < ActionController::TestCase
  setup do
    @status = statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:statuses)
  end

  test "should display all user's posts when not logged in" do
    users(:blocked_friend).statuses.create(content: 'Blocked status')
    users(:perro).statuses.create(content: 'Non-blocked status')
    get :index
    assert_match /Non\-blocked status/, response.body
    assert_match /Blocked\ status/, response.body
  end 


  test "should not display blocked user's posts when logged in" do
    sign_in users(:alex)
    users(:blocked_friend).statuses.create(content: 'Blocked status')
    users(:perro).statuses.create(content: 'Non-blocked status')
    get :index
    assert_match /Non\-blocked status/, response.body
    assert_no_match /Blocked\ status/, response.body
  end 




  test "should be redirected when not logged in" do
    get :new
    assert_response :redirect 
    assert_redirected_to new_user_session_path
  end

  test "should render the :new page when logged in" do
    sign_in users(:alex)
    get :new
    assert_response :success
  end

# --- For posting a status ---

  test "should be logged in to post a status" do
    post :create, status: { content: "Hello"}
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should create/post status when logged in" do
    sign_in users(:alex) # Added to enable this test to pass with the login requirenment
    assert_difference('Status.count') do
      post :create, status: { content: @status.content}
    end

    assert_redirected_to status_path(assigns(:status))
  end


  test "should create/post status for the current user when logged in" do
    sign_in users(:alex) 
    assert_difference('Status.count') do
      post :create, status: { content: @status.content, user_id: users(:perro).id }
    end

    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:alex).id
  end


  # *** for activity model ***

  test "should create an activity item for the status when logged in" do
    sign_in users(:alex) 
    assert_difference('Activity.count') do
      post :create, status: { content: @status.content}
    end
  end

  # *** End of: activity model ***


# ------------- End of: For posting a status-------------



  test "should show status" do
    get :show, id: @status
    assert_response :success
  end



# ------------ For editing a status -------------
  test " edit should be redirected when not signed in" do
    get :edit, id: @status
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should render the :edit page when logged in" do
    sign_in users(:alex)
    get :edit, id: @status
    assert_response :success
  end
# ------------- End of: For editing a status-------------




# --------------- For updating a status ----------------
  test "should redirect status update when not logged in" do
    patch :update, id: @status, status: {content: @status.content}
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should update status when logged in" do
    sign_in users(:alex)
    patch :update, id: @status, status: { content: @status.content}
    assert_redirected_to status_path(assigns(:status))
  end

  test "should update status for current user when logged in" do
    sign_in users(:alex)
    put :update, id: @status, status: { content: @status.content, user_id: users(:alex).id }
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:alex).id 
  end

  # *** for activity model ***
  test "should create an activity for the update status when logged in" do
    sign_in users(:alex)
    assert_difference('Activity.count') do
      patch :update, id: @status, status: { content: @status.content}
    end
  end
  # *** End of: activity model ***

# ------------- End of: For updating a status-------------




# ----------------- For deleting a status -----------------

  test "should destroy status when logged in" do
    sign_in users(:alex)
    assert_difference('Status.count', -1) do
      delete :destroy, id: @status
    end

    assert_redirected_to statuses_path
  end

 test "should redirect status destroy when not logged in" do
    delete :destroy, id: @status
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end


  # *** for activity model ***
  test "should create an activity for the destroy status when logged in" do
    sign_in users(:alex)
    assert_difference('Activity.count') do
      delete :destroy, id: @status
    end
  end
  # *** End of: activity model ***

# ------------- End of: For deleting a status-------------

end








