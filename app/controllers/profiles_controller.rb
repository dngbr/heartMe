class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: [:share]
  before_action :set_profile, only: [:show, :edit, :update]
  
  def show
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
  
  def share
    @profile = Profile.find_by_share_id(params[:id])
    
    if @profile
      render :share
    else
      redirect_to root_path, alert: 'Profile not found.'
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
