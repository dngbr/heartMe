class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
         
  has_one :profile, dependent: :destroy
  
  after_create :build_default_profile
  
  private
  
  def build_default_profile
    create_profile
  end
end
