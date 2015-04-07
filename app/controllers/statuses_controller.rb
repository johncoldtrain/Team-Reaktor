class StatusesController < ApplicationController
  
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy] # Only for new statuses
  # This came from the Devise documentation in GitHub

  before_action :set_status, only: [:show, :edit, :update, :destroy]

  # GET /statuses
  # GET /statuses.json
  def index
    @statuses = Status.order('created_at desc').all
  end

  # GET /statuses/1
  # GET /statuses/1.json
  def show
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

    respond_to do |format|
      if @status.update(status_params) && @document && @document.update_attributes(status_params[:document_attributes])
        format.html { redirect_to @status, notice: 'Status was successfully updated.' }
        format.json { render :show, status: :ok, location: @status }
      else
        format.html { render :edit }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /statuses/1
  # DELETE /statuses/1.json
  def destroy
    @status.destroy
    respond_to do |format|
      format.html { redirect_to statuses_url, notice: 'Status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status
      @status = Status.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def status_params
      params.require(:status).permit(:name, :user_id, :content, document_attributes: [:attachment, :remove_attachment] ) if params[:status]
    end

end
