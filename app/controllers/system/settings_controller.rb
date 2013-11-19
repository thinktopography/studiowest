class System::SettingsController < System::ApplicationController

  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes params[:user]
      flash[:notice] = "Your settings have been successfully updated"
      redirect_to reservations_url
    else
      flash[:warning] = "There was a problem with your input"
      render "edit"
    end
  end
  
  def company
    @company = current_user.company
    unless params[:company].nil?
      if @company.update_attributes(params[:company])
        redirect_to reservations_url
      end
    end
  end
  
  def terms
    @user = current_user
    unless params[:user].nil?
      if @user.update_attributes(params[:user])
        redirect_to reservations_url
      end
    end
  end
  
  def code
    @show_code = false
    @user = current_user
    unless params[:user].nil?
      if(@user.valid_password?(params[:user][:password]))
        @show_code = true
      end
    end
  end
  
  def password
    @user = current_user
    unless params[:user].nil?
      if @user.update_attributes(params[:user])
        sign_in(@user, :bypass => true)
        redirect_to reservations_url
      end
    end
  end  
  
  def changepassword
    @user = current_user
    unless params[:user].nil?
      @user.change_password = false
      if @user.update_attributes(params[:user])
        sign_in(@user, :bypass => true)
        redirect_to reservations_url
      end
    end
  end  

end