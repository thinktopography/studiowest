class Reservation < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :membership
  belongs_to :resource
  
  #before_destroy :validate_deletion
  
  validate :custom_validation

  scope :upcoming, where('start > NOW()').order('start ASC')
  
  def date
    @date
  end

  def date=(date)
    @date = date
  end

  def start_time
    @start_time
  end

  def start_time=(time)
    @start_time = time
  end
  
  def end_time
    @end_time
  end

  def end_time=(time)
    @end_time = time
  end
  
  def day_of_week
    self.start.wday    
  end
  
  def start_in_units
    (self.start.in_time_zone.strftime("%k").to_i - 7) * 4 + (self.start.strftime("%M").to_i / 15) + 1
  end
    
  def length_in_units
    (self.end - self.start) / 900
  end
  
  private

    def custom_validation
      # VALIDATES PRESENCE OF
      errors.add(:date, 'Please enter a date') if self.date.blank?
      errors.add(:start_time, 'Please enter a start time') if self.start_time.blank?
      errors.add(:end_time, 'Please enter an end time') if self.end_time.blank?
      errors.add(:resource_id, 'Please choose a resource') if self.resource_id.blank?
      return false unless errors.empty?
      merge_time
      # CHECK FOR VALID MEMBERSHIP
      memberships = self.user.memberships.where('start = ?', self.start.to_date.beginning_of_month)
      unless memberships.empty?
        self.membership_id = memberships.first.id
      else
        return errors.add(:date, 'You cannot make reservations for this month')
      end
      # VALIDATE START TIME
      start_of_business = Time.parse("07:00:00")
      start_of_reservation = Time.parse(self.start.strftime("%H:%M:%S"))
      if start_of_reservation < start_of_business
        return errors.add(:start_time, 'This reservation begins before business hours')
      end
      # VALIDATE END TIME
      end_of_business = Time.parse("23:00:00")
      end_of_reservation = Time.parse(self.end.strftime("%H:%M:%S"))
      if end_of_reservation > end_of_business
        return errors.add(:end_time, 'This reservation ends after business hours')
      end
      # VALIDATE RANGE
      unless self.end > self.start
        return errors.add(:end_time, 'This reservation cannot end before it begins')
      end
      # VALIDATE SUFFICIENT CREDITS
      calculate_credits
      if self.credits > self.membership.available_credits
        return errors.add(:resource_id, 'There are not enough available credits for this reservation')
      end
      # VALIDATE SCHEDULING CONFLICTS
      conflicts = Reservation.where(:resource_id => self.resource_id).where('start < ? AND end > ?', self.end, self.start)
      conflicts = conflicts.where("id != ?", self.id) unless self.new_record?
      unless conflicts.empty?
        return errors.add(:resource_id, 'This reservation conflicts with another reservation')
      end
      conflicts = Event.where('start < ? AND end > ?', self.end, self.start)
      unless conflicts.empty?
        return errors.add(:resource_id, 'This reservation conflicts with an event')
      end
    end
  
    def validate_deletion
      errors.add_to_base "Cannot delete a reservation within 15 minutes of start" unless booking_payments.count == 0
      return false
    end
    
    def merge_time
      self.start = Time.parse("#{@date} #{@start_time}")
      self.end = Time.parse("#{@date} #{@end_time}")
    end

    def calculate_credits
      start_of_reservation = Time.parse(self.start.strftime("%H:%M:%S"))
      end_of_reservation = Time.parse(self.end.strftime("%H:%M:%S"))
      if self.start.wday > 0 && self.start.wday < 6
        peak_time_end = Time.parse("18:00:00")
        peak_units = ([end_of_reservation, peak_time_end].min - start_of_reservation) / 3600
        peak_credits = self.resource.peak_credits * peak_units
        off_peak_units = ([end_of_reservation, peak_time_end].max - peak_time_end) / 3600
        off_peak_credits = self.resource.off_peak_credits * off_peak_units
        self.credits = peak_credits + off_peak_credits
      else
        peak_credits = 0
        off_peak_units = (end_of_reservation - start_of_reservation) / 3600
        off_peak_credits = self.resource.off_peak_credits * off_peak_units
      end
      self.credits = peak_credits + off_peak_credits
    end
    
  
end