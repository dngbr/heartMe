class HeartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_receiver, only: [:create, :destroy]
  
  # POST /hearts or /heart/:id
  def create
    # Check if user is trying to heart themselves
    if current_user.id == @receiver.id
      respond_to do |format|
        format.html { redirect_to profile_path(@receiver.profile), alert: "You cannot heart your own profile" }
        format.json { render json: { error: "You cannot heart your own profile" }, status: :unprocessable_entity }
      end
      return
    end
    
    # Create the heart
    @heart = Heart.new(giver: current_user, receiver: @receiver)
    
    respond_to do |format|
      if @heart.save
        format.html { redirect_to profile_path(@receiver.profile), notice: "You've hearted this profile!" }
        format.json { render json: { success: true, hearts_count: @receiver.hearts_received_count } }
      else
        format.html { redirect_to profile_path(@receiver.profile), alert: @heart.errors.full_messages.join(", ") }
        format.json { render json: { error: @heart.errors.full_messages.join(", ") }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hearts/:id or /unheart/:id
  def destroy
    @heart = current_user.given_hearts.find_by(receiver: @receiver)
    
    if @heart
      @heart.destroy
      respond_to do |format|
        format.html { redirect_to profile_path(@receiver.profile), notice: "You've unhearted this profile" }
        format.json { render json: { success: true, hearts_count: @receiver.hearts_received_count } }
      end
    else
      respond_to do |format|
        format.html { redirect_to profile_path(@receiver.profile), alert: "You haven't hearted this profile yet" }
        format.json { render json: { error: "Heart not found" }, status: :not_found }
      end
    end
  end
  
  private
  
  def set_receiver
    @receiver = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to root_path, alert: "User not found" }
      format.json { render json: { error: "User not found" }, status: :not_found }
    end
  end
end
