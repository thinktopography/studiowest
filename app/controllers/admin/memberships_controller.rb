class Admin::MembershipsController < ApplicationController
  
  def overview
    @plans = Plan.find :all
  end

end