# Simple configuration to allow all attributes and associations to be ransackable
# This is less secure but more convenient for development

# Monkey patch ActiveRecord::Base to allow all attributes and associations to be ransackable
ActiveRecord::Base.class_eval do
  def self.ransackable_attributes(auth_object = nil)
    column_names + _ransackers.keys
  end

  def self.ransackable_associations(auth_object = nil)
    reflect_on_all_associations.map { |a| a.name.to_s }
  end

  def self.ransortable_attributes(auth_object = nil)
    ransackable_attributes(auth_object)
  end
end
