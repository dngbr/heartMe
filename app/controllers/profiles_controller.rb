class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: [:view_shared_profile]
  before_action :set_profile, only: [:show, :edit, :update, :fans, :hearted]
  
  def show
    @fans = @profile.user.fans.includes(:profile).limit(10)
    @hearted_users = @profile.user.hearted_users.includes(:profile).limit(10)
  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path(@profile), notice: 'Profile was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def view_shared_profile
    encrypted_id = params[:code]
    share_id = EncryptionHelper.decrypt_share_id(encrypted_id)
    
    if share_id
      @profile = Profile.find_by_share_id(share_id)
      
      if @profile
        if user_signed_in? && current_user.profile == @profile
          redirect_to profile_path(@profile)
          return
        end
        
        @fans = @profile.user.fans.includes(:profile).limit(10)
        @hearted = user_signed_in? ? current_user.has_hearted?(@profile.user) : false
        
        render :view_shared_profile
        return
      end
    end
    
    redirect_to root_path, alert: 'Profile not found. Please scan the QR code again.'
  end
  
  def fans
    if current_user && current_user.id == @profile.user_id
      @fans = @profile.user.fans.includes(:profile).page(params[:page]).per(20)
    else
      redirect_to root_path, alert: 'You do not have permission to view this page.'
    end
  end
  
  def hearted
    if current_user && current_user.id == @profile.user_id
      @hearted_users = @profile.user.hearted_users.includes(:profile).page(params[:page]).per(20)
    else
      redirect_to root_path, alert: 'You do not have permission to view this page.'
    end
  end
  
  def update_profile_picture
    @profile = current_user.profile
    
    if params[:profile] && params[:profile][:profile_picture]
      if @profile.profile_picture.attached?
        @profile.profile_picture.purge
      end
      
      @profile.profile_picture.attach(params[:profile][:profile_picture])
      render json: { 
        success: true, 
        image_url: url_for(@profile.profile_picture)
      }
    else
      render json: { success: false, error: "No image provided" }, status: 422
    end
  end
  
  def update_background_picture
    @profile = current_user.profile
    
    if params[:profile] && params[:profile][:background_picture]
      if @profile.background_picture.attached?
        @profile.background_picture.purge
      end
      
      @profile.background_picture.attach(params[:profile][:background_picture])
      render json: { 
        success: true, 
        image_url: url_for(@profile.background_picture)
      }
    else
      render json: { success: false, error: "No image provided" }, status: 422
    end
  end
  
  private
  
  def set_profile
    @profile = params[:id] ? Profile.find(params[:id]) : current_user.profile
  end
  
  def profile_params
    params.require(:profile).permit(:name, :bio, :profile_picture, :background_picture)
  end
end
