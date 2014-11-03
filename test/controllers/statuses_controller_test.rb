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

# *******************************************************
# Original test before changing it below
#   test "should get new" do
#     get :new
#     assert_response :success
#   end

# Modified to send to login before creating a new status 
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

# --------------------------

  test "should show status" do
    get :show, id: @status
    assert_response :success
  end


# --- For editing a status ---
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
# -----------------------------


# --- For updating a status ---
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
# -----------------------------


  test "should destroy status" do
    assert_difference('Status.count', -1) do
      delete :destroy, id: @status
    end

    assert_redirected_to statuses_path
  end
end
