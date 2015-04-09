require 'test_helper'

class PicturesControllerTest < ActionController::TestCase
  setup do
    @picture = pictures(:one_pic)
    @album = albums(:one)
    @user = users(:alex)
    @album.user_id = @user.id
    @picture.album_id = @album.id
    @picture.user_id = @user.id
    @picture.save
    @album.save

    sign_in @user
  end

  test "should get index" do
    get :index, profile_name: @user.profile_name, album_id: @album.id
    assert_response :success
    assert_not_nil assigns(:pictures)
  end

  test "should get new" do
    get :new, profile_name: @user.profile_name, album_id: @album.id
    assert_response :success
  end

  test "should create picture" do
    assert_difference('Picture.count') do
      post :create, profile_name: @user.profile_name, album_id: @album.id, picture: { album_id: @picture.album_id, caption: @picture.caption, description: @picture.description, user_id: @picture.user_id }
    end

    assert_redirected_to album_pictures_path(@album.id)
  end

  test "should show picture" do
    get :show, profile_name: @user.profile_name, album_id: @album.id, id: @picture
    assert_response :success
  end

  test "should get edit" do
    get :edit, profile_name: @user.profile_name, album_id: @album.id, id: @picture
    assert_response :success
  end

  test "should update picture" do
    patch :update, profile_name: @user.profile_name, album_id: @album.id, id: @picture, picture: { album_id: @picture.album_id, caption: @picture.caption, description: @picture.description, user_id: @picture.user_id }
    
    assert_redirected_to album_pictures_path(@album.id)
  end

  test "should destroy picture" do
    assert_difference('Picture.count', -1) do
      delete :destroy, profile_name: @user.profile_name, album_id: @album.id, id: @picture
    end

    assert_redirected_to album_path(@album.id)
  end
end
