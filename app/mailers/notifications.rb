class Notifications < ActionMailer::Base
  default :from => "notifications@studiowestithaca.com"
    
  def welcome(user)
    @user = user
    @temporary_password = user.password
    from = "Studio West <notifications@studiowestithaca.com>"
    to = @user.email
    bcc = "Greg Kops <greg@thinktopography.com>"
    mail(:from => from, :to => to, :bcc => bcc, :subject => 'Welcome to Studio West')
  end
    
  def renew(user)
    @user = user
    from = "Studio West <notifications@studiowestithaca.com>"
    to = @user.email
    bcc = "Greg Kops <greg@thinktopography.com>"
    mail(:from => from, :to => to, :bcc => bcc, :subject => 'Happy Holidays and Membership Update')
  end

  def openhouse(first,last,email)
    @first_name = first
    from = "Studio West <notifications@studiowestithaca.com>"
    to = "#{first} #{last} <#{email}>"
    mail(:from => from, :to => to, :subject => 'Thank You!')
  end

end
