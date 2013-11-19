class Inquiry < ActiveRecord::Base
  
  validates_presence_of :first_name, :last_name, :email, :phone
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
end
