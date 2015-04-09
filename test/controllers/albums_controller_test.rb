require 'test_helper'

class AlbumsControllerTest < ActionController::TestCase
  setup do
    @album = albums(:one)
    @user = users(:alex)
    @album.user_id = @user.id
    @album.save
    sign_in users(:alex)
  end

  test "should get index" do
    get :index, profile_name: @user.profile_name
    assert_response :success
    assert_not_nil assigns(:albums)
  end

  test "should get new" do
    get :new, profile_name: @user.profile_name
    assert_response :success
  end

  test "should create album" do
    assert_difference('Album.count') do
      post :create, profile_name: @user.profile_name, album: { title: @album.title, user_id: @user.id }
    end
    assert_redirected_to album_path(@user.profile_name, assigns(:album))
  end

  # *** for activity model ***
  test "should create activity for the create album" do
    assert_difference 'Activity.count', 1 do
      post :create, profile_name: @user.profile_name, album: { title: @album.title, user_id: @user.id }
    end
  end
  # *** End of: activity model ***


  test "should show album" do
    get :show, profile_name: @user.profile_name, id: @album
    assert_response :redirect
    assert_redirected_to album_pictures_path(@user.profile_name, @album)
  end

  test "should get edit" do
    get :edit, profile_name: @user.profile_name, id: @album
    assert_response :success
  end

  test "should update album" do
    patch :update, profile_name: @user.profile_name, id: @album, album: { title: @album.title }
    assert_response :redirect
    assert_redirected_to album_path(@user.profile_name, @album)
  end

  # *** for activity model ***
  test "should create activity for the update album" do
    assert_difference 'Activity.count', 1 do
      patch :update, profile_name: @user.profile_name, id: @album, album: { title: @album.title }
    end
  end
  # *** End of: activity model ***

  test "should destroy album" do
    assert_difference('Album.count', -1) do
      delete :destroy, profile_name: @user.profile_name, id: @album
    end

    assert_redirected_to albums_path
  end


  # *** for activity model ***
  test "should create activity for the destroy album" do
    assert_difference 'Activity.count', 1 do
      delete :destroy, profile_name: @user.profile_name, id: @album
    end
  end
  # *** End of: activity model ***

  
end






