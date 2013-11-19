class SiteController < ApplicationController
  
  layout "site"
  
  def index
    @inquiry = Inquiry.new
    unless params[:inquiry].nil?
      @inquiry.attributes = params[:inquiry]
      if @inquiry.save
        InquiryMailer.notification(@inquiry).deliver!
        redirect_to thankyou_url
      end
    end
  end

  def thankyou
  end

  
end
