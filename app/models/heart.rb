class Heart < ApplicationRecord
  # Associations
  belongs_to :giver, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  
  # Validations
  validates :giver_id, uniqueness: { scope: :receiver_id, message: "You've already hearted this profile" }
  validate :cannot_heart_self
  
  private
  
  # Prevent users from hearting their own profile
  def cannot_heart_self
    if giver_id == receiver_id
      errors.add(:base, "You cannot heart your own profile")
    end
  end
end
