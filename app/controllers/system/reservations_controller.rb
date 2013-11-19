class System::ReservationsController < System::ApplicationController

  def index
    @reservation = Reservation.new(:date => Date.today)
    day    
  end
  
  def upcoming
    params[:user_id] ||= current_user.id
    @user = User.find params[:user_id]
    @reservations = @user.reservations.upcoming
  end

  def resource
    params[:date] ||= Date.today.strftime('%Y-%m-%d')
    params[:resource_id] ||= '1'
    date = Date.parse(params[:date])
    @next = date.in(7.days).strftime('%Y-%m-%d')
    @prev = date.ago(7.days).strftime('%Y-%m-%d')
    @start = date.tomorrow.beginning_of_week.ago(1.day).utc
    @finish = date.tomorrow.end_of_week.ago(1.second).utc
    @reservations = {}
    @resource = Resource.find params[:resource_id]
    reservations = @resource.reservations.includes(:user).where("start >= ? AND end <= ?", @start, @finish)
    reservations.each do |reservation|
      @reservations[reservation.day_of_week] = {} unless @reservations.include?(reservation.day_of_week)
      @reservations[reservation.day_of_week][reservation.start_in_units] = {} unless @reservations[reservation.day_of_week].include?(reservation.start_in_units)
      @reservations[reservation.day_of_week][reservation.start_in_units] = reservation
    end
    events = Event.where("start >= ? AND end <= ?", @start, @finish)
    events.each do |event|
      @reservations[event.day_of_week] = {} unless @reservations.include?(event.day_of_week)
      @reservations[event.day_of_week][event.start_in_units] = {} unless @reservations[event.day_of_week].include?(event.start_in_units)
      @reservations[event.day_of_week][event.start_in_units] = event
    end
  end
  
  def day
    params[:date] ||= Date.today.strftime('%Y-%m-%d')
    params[:id] ||= ""
    @date = Date.parse(params[:date])
    @start = Time.parse("#{params[:date]} 00:00:00").utc
    @finish = Time.parse("#{params[:date]} 23:59:59").utc
    @next = @date.tomorrow
    @prev = @date.yesterday
    @resources = Resource.find(:all)
    @reservations = {}
    reservations = Reservation.includes(:user).where("start >= ? AND end <= ?", @start, @finish)
    reservations.each do |reservation|
      @reservations[reservation.resource_id] = {} unless @reservations.include?(reservation.resource_id)
      @reservations[reservation.resource_id][reservation.start_in_units] = {} unless @reservations[reservation.resource_id].include?(reservation.start_in_units)
      @reservations[reservation.resource_id][reservation.start_in_units] = reservation
    end
    @events = {}
    events = Event.where("start >= ? AND end <= ?", @start, @finish)
    events.each do |event|
      @events = {} unless @reservations.include?(event.day_of_week)
      @events[event.start_in_units] = {} unless @events.include?(event.start_in_units)
      @events[event.start_in_units] = event
    end
  end
  
  def new
    @reservation = Reservation.new(:date => Date.today)
    render :partial => "new"
  end
  
  def create
    @reservation = current_user.reservations.new(params[:reservation])
    if @reservation.save
      @reservation = Reservation.new(:date => Date.today)
      render :status => 200, :partial => "new"
    else
      render :status => 201, :partial => "new"
    end
  end
  
  def cancel
    @reservation = Reservation.find(params[:id])
    if @reservation.destroy
      render :status => 200, :text => ''
    else
      render :status => 500, :text => ''
    end
  end
  
  def history
    params[:start] ||= '2012-01-01'
    params[:end] ||= Time.now.strftime("%Y-%m-%d")
    @reservations = current_user.reservations.where("start >= ? AND end <= ?", params[:start], params[:end])
  end
  
end
