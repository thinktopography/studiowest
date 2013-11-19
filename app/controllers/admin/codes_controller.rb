class Admin::CodesController < Admin::ApplicationController
  
  def index
    @codes = Code.find(:all)
  end
  
end