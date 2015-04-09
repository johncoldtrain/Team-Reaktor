class AlbumsController < ApplicationController

  before_filter :authenticate_user!, only: [:create, :new, :update, :edit, :destroy]
  before_filter :find_user
  before_filter :ensure_proper_user, only: [:edit, :new, :create, :destroy]

  before_action :set_album, only: [ :edit, :update, :destroy]

  before_action :add_breadcrumbs

  respond_to :html

  def index
    @albums = @user.albums.all
    respond_with(@albums)
  end

  def show
    redirect_to album_pictures_path(params[:id])
  end

  def new
    @album = current_user.albums.new
    respond_with(@album)
  end

  def edit
    add_breadcrumb "Editing Album"
  end

  def create
    @album = current_user.albums.new(album_params)
    @album.save

    current_user.create_activity(@album, 'created') # <=== For the activity model feed

    respond_with(@album)
  end

  def update
    @album.update(album_params)
    current_user.create_activity(@album, 'updated') # <=== For the activity model feed
    respond_with(@album)
  end

  def destroy
    @album.destroy
    current_user.create_activity(@album, 'deleted') # <=== For the activity model feed
    respond_with(@album)
  end

# +++++++ Over ride the inherited super-method url_options
  def url_options
    { profile_name: params[:profile_name] }.merge(super)
  end


  private

  def add_breadcrumbs
    add_breadcrumb @user.first_name, profile_path(@user)
    add_breadcrumb "Albums", albums_path
  end

  def ensure_proper_user
      if current_user != @user
        flash[:alert] = "You don't have permission to do that."
        redirect_to albums_path
      end
    end

  def set_album
    @album = current_user.albums.find(params[:id])
  end

  def album_params
    params.require(:album).permit(:user_id, :title)
  end

  def find_user
    @user = User.find_by_profile_name(params[:profile_name])
  end



end
