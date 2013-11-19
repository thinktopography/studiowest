class InquiryMailer < ActionMailer::Base

  default :from => "notifications@studiowestithaca.com"
    
  def notification(inquiry)
    @inquiry = inquiry
    from = "Studio West <notifications@studiowestithaca.com>"
    to = "Hello <hello@studiowestithaca.com>"
    mail(:from => from, :to => to, :subject => 'Website Signup')
  end

end