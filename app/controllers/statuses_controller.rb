class StatusesController < ApplicationController
  
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :post_comment, :destroy_comment] # Only for new statuses
  # This came from the Devise documentation in GitHub

  before_action :set_status, only: [:show, :edit, :update, :destroy, :post_comment]

  # GET /statuses
  # GET /statuses.json
  def index
    @statuses = Status.order('created_at desc').all
  end

  # GET /statuses/1
  # GET /statuses/1.json
  def show
    @comments = @status.comments.recent.limit(10).all 
    # post_comment
  end 

  # GET /statuses/new
  def new
    @status = Status.new
    @status.build_document # <- from paperclip to prepare to receive the attachment
  end

  # GET /statuses/1/edit
  def edit
  end

  # POST /statuses
  # POST /statuses.json
  def create
    @status = current_user.statuses.new(status_params) #changed from Status.new to current_user
    # In order to scope to the logged in user, as we are required to be logged in.

    respond_to do |format|
      if @status.save

        current_user.create_activity(@status, 'created') # <=== For the activity model feed

        format.html { redirect_to @status, notice: 'Status was successfully created.' }
        format.json { render :show, status: :created, location: @status }
      else
        format.html { render :new }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /statuses/1
  # PATCH/PUT /statuses/1.json
  def update
    @document = @status.document

    @comments = @status.comments

    @status.transaction do
      current_user.create_activity(@status, 'updated') # <=== For the activity model feed

      @status.update_attributes(status_params)
      @document.update_attributes(status_params[:document_attributes]) if @document

      unless @status.valid? || (@status.valid? && @document && !@document.valid?)
        raise ActiveRecord::Rollback
      end
    end

    respond_to do |format|
        format.html { redirect_to @status, notice: 'Status was successfully updated.' }
        format.json { render :show, status: :ok, location: @status }
    end

    rescue ActiveRecord::Rollback
      respond_to do |format|
        format.html do
          flash.now[:alert] = "Update failed."
          render action: "edit"
        end 
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
  end


  # DELETE /statuses/1
  # DELETE /statuses/1.json
  def destroy
    @status.destroy
    current_user.create_activity(@status, 'deleted') # <=== For the activity model feed
    respond_to do |format|
      format.html { redirect_to statuses_url, notice: 'Status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  # ====== Comments Methods =======

  def post_comment   
    @status.transaction do 
      comment = Comment.new(comment_params)
      comment.user_id = current_user.id
      @status.comments << comment
      comment.save

      current_user.create_activity(@status, 'commented') # <=== For the activity model feed
    end

    redirect_to :action => :show, :id => @status
  end

  def destroy_comment
    comment = Comment.find_by_id(params[:id])
    @status = Status.find_by_id(comment.commentable_id)
    comment.destroy
    redirect_to :action => :show, :id => @status
  end

  # ======= End of Comments ======== 


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status
      @status = Status.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def status_params
      params.require(:status).permit(:name, :user_id, :content, document_attributes: [:attachment, :remove_attachment]) if params[:status]
    end

    def comment_params
      params.require(:comment).permit(:title, :comment, :user_id, :comentable_id, :comentable_type)
    end



end
