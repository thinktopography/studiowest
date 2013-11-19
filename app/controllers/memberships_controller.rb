class MembershipsController < ApplicationController
  
  layout "site"

  def new
    @user = User.new
    @company = @user.build_company
    @membership = @user.memberships.build(:plan_id => 1, :until => Date.today.end_of_month)
  end
  
  def create
    @user = User.new(params[:user])
    @company = @user.build_company(params[:company])
    @membership = @user.memberships.build(params[:membership])
    @membership.start = Date.today.beginning_of_month
    if @company.valid? & @user.save
      ending = Date.parse(@membership.until)
      beginning = @membership.start
      while ending > beginning.end_of_month
        beginning = beginning.next_month.beginning_of_month
        @user.memberships.create(:plan_id => @membership.plan_id, :start => beginning)
      end
      render "thankyou"
    else
      render "new"
    end
  end
  
  def pricing
  end

end