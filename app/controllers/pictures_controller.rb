class PicturesController < ApplicationController

  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  before_action :find_user
  before_filter :ensure_proper_user, only: [:edit, :new, :create, :destroy]

  before_action :find_album
  before_action :set_picture, only: [:show, :edit, :update, :destroy]

  before_action :add_breadcrumbs

  respond_to :html

  def index
    @pictures = @album.pictures.all
    respond_with(@pictures)
  end

  def show
    add_breadcrumb @picture.caption
    respond_with(@picture)
  end

  def new
    @picture = @album.pictures.new
    respond_with(@picture)
  end

  def edit

  end


  def create
    @picture = @album.pictures.new(picture_params)
    @picture.user = current_user

    current_user.create_activity(@picture, 'created') # <=== For the activity model feed

    respond_to do |format|
      if @picture.save
        format.html { redirect_to album_pictures_path(@album), notice: 'Picture was successfully added.'}
        format.json { render json: @picture, status: :created, location: @picture }
      else
        format.html { render action: "new" }
        format.json { render json: @picture.errors, status: :unprocessable_entry}
      end
    end
  end



  def update
    respond_to do |format|
      if @picture.update_attributes(picture_params)

        current_user.create_activity(@picture, 'updated') # <=== For the activity model feed

        format.html { redirect_to album_pictures_path(@album), notice: 'Picture was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end  
  end



  def destroy
    @picture.destroy
    current_user.create_activity(@picture, 'deleted') # <=== For the activity model feed
    respond_with(@album)
  end


  def url_options
    { profile_name: params[:profile_name] }.merge(super)
  end




  private

    def add_breadcrumbs
      add_breadcrumb @user.first_name, profile_path(@user)
      add_breadcrumb "Albums", albums_path
      add_breadcrumb "Pictures", album_pictures_path(@album)
    end


    def ensure_proper_user
      if current_user != @user
        flash[:alert] = "You don't have permission to do that."
        redirect_to album_pictures_path
      end
    end



    def find_user
      @user = User.find_by_profile_name(params[:profile_name])
    end


    def find_album
      if signed_in? && current_user.profile_name == params[:profile_name]
        @album = current_user.albums.find(params[:album_id])
      else
        @album = @user.albums.find(params[:album_id])
      end
    end


    def set_picture
      @picture = @album.pictures.find(params[:id])
    end

    def picture_params
      params.require(:picture).permit(:album_id, :user_id, :caption, :description, :asset)
    end
end
