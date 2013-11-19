class System::ApplicationController < ApplicationController

  before_filter :authenticate_user!
  before_filter :check_warnings
  
  private
  
    def check_warnings
      if !current_user.agreed_to_terms && self.action_name != 'terms'
        redirect_to terms_settings_url
      elsif current_user.agreed_to_terms && current_user.change_password && self.action_name != 'changepassword'
        redirect_to changepassword_settings_url
      end
    end
  
end