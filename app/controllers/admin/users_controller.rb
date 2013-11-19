class Admin::UsersController < Admin::ApplicationController
  
  def index
    @users = User.find(:all)
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def welcome
    @user = User.find(params[:id])
    @user.password = SecureRandom.hex(6).to_s.upcase[0,6]
    @user.change_password = true
    @user.save
    sign_in(@user, :bypass => true) if @user.id == current_user.id
    Notifications.welcome(@user).deliver
    render :text => 'sent'
    #render "notifications/welcome", :layout => false
  end
  
  def openhouse
    if params[:upload]
      data = params[:upload][:file].read
      output = []
      lines = data.gsub(/\r\n/, "\r").gsub(/\n/, "\r").split("\r")
      lines.each do |line|
        args = line.split(",")
        if Notifications.openhouse(args[0],args[1],args[2]).deliver
          output << "#{args[0]} #{args[1]} &lt;#{args[2]}&gt;: SENT"
        else 
          output << "#{args[0]} #{args[1]} &lt;#{args[2]}&gt;: FAILED"
        end
      end    
      render :text => output.join('<br />')
    else
      render "openhouse"
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to user_url(@user)
    else
      flash[:error] = 'There were problems with your input'
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to user_url(@user)
    else
      flash[:error] = 'There were problems with your input'
      render :action => 'edit'
    end
  end

end