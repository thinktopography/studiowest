class Admin::InquiriesController < Admin::ApplicationController
  
  def index
    @inquiries = Inquiry.find(:all)
  end

end
