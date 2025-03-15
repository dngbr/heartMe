class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
         
  # Profile association
  has_one :profile, dependent: :destroy
  
  # Heart associations
  # Hearts given to other users
  has_many :given_hearts, class_name: 'Heart', foreign_key: 'giver_id', dependent: :destroy
  has_many :hearted_users, through: :given_hearts, source: :receiver
  
  # Hearts received from other users
  has_many :received_hearts, class_name: 'Heart', foreign_key: 'receiver_id', dependent: :destroy
  has_many :fans, through: :received_hearts, source: :giver
  
  after_create :build_default_profile
  
  # Check if this user has hearted another user
  def has_hearted?(user)
    given_hearts.exists?(receiver_id: user.id)
  end
  
  # Heart count methods
  def hearts_given_count
    given_hearts.count
  end
  
  def hearts_received_count
    received_hearts.count
  end
  
  private
  
  def build_default_profile
    create_profile
  end
end
