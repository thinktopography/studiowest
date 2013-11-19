class Company < ActiveRecord::Base
  
  has_attached_file :logo, :path => "public/system/logos/:id/:style/:filename", :styles => { :medium => 'x48', :large => 'x150' }

  has_many :users
  
  validates_presence_of :name

  def logo_url(style)
    (!self.logo_file_name.nil?) ? self.logo.url(style) : "company.jpg"
  end
  
end