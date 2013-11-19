class Event < ActiveRecord::Base
  
  def day_of_week
    self.start.wday    
  end
  
  def start_in_units
    (self.start.strftime("%k").to_i - 7) * 4 + (self.start.strftime("%M").to_i / 15) + 1
  end
    
  def length_in_units
    (self.end - self.start) / 900
  end
  
end