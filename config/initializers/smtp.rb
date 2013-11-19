ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "studiowestithaca.com",
  :user_name            => "notifications@studiowestithaca.com",
  :password             => "th1nking!",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
