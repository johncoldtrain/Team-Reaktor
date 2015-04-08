class PicturesController < ApplicationController

  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  before_action :find_user
  before_action :find_album

  before_action :set_picture, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @pictures = @album.pictures.all
    respond_with(@pictures)
  end

  def show
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
    respond_with(@picture)
  end


  def url_options
    { profile_name: params[:profile_name] }.merge(super)
  end

  private

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
