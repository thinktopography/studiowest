class Admin::ApplicationController < ApplicationController

  before_filter :authenticate_user!
  before_filter :user_is_admin
  before_filter :agreed_to_terms
  
  private
  
    def user_is_admin
      unless current_user.is_admin
        render 'site/403'
      end
    end
  
    def agreed_to_terms
      if !current_user.agreed_to_terms && self.action_name != 'terms'
        redirect_to terms_settings_url
      end
    end
  
end