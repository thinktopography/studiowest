class Resource < ActiveRecord::Base
  
  has_many :reservations
  
end
