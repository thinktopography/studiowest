class ApplicationController < ActionController::Base

  layout :choose_layout
  protect_from_forgery
  before_filter :set_user_time_zone
  
  private

    def after_sign_in_path_for(resource)
      reservations_url
    end  

    def choose_layout
      if devise_controller?
        "site"
      elsif request.xhr?
        "ajax"
      else
        "application"
      end
    end

    def set_user_time_zone
      Time.zone = 'Eastern Time (US & Canada)'
    end
  
end