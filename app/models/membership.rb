class Membership < ActiveRecord::Base
  
  attr_accessor :until

  belongs_to :user
  belongs_to :plan
  has_many :reservations
  
  scope :unexpired, where('MONTH(start) >= MONTH(NOW()) AND YEAR(start) >= YEAR(NOW())')
  
  def until=(date)
    @until = date
  end
  
  def until
    @until
  end
  
  def used_credits
    self.reservations.sum("credits").to_f
  end

  def available_credits
    self.credits - self.used_credits
  end
  
  def before_create
    self.credits = plan.credits
  end

end