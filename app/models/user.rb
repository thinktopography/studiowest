class User < ActiveRecord::Base
  
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,:token_authenticatable
  attr_accessible :first_name, :last_name, :email, :phone, :password, :password_confirmation, :remember_me, :avatar, :agreed_to_terms, :change_password

  has_attached_file :avatar, :path => "public/system/avatars/:id/:style/:filename", :styles => { :small => 'x16', :medium => 'x48', :large => 'x60' }

  belongs_to :company
  belongs_to :code
  has_many :memberships
  has_many :reservations
  
  default_scope order("first_name ASC")
  
  validates_presence_of :first_name, :last_name, :email, :phone

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def avatar_url(style)
    (!self.avatar_file_name.nil?) ? self.avatar.url(style) : "person.jpg"
  end
  
end
