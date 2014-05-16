class Fixnum
  SECONDS_IN_MINUTE = 60
  MINUTES_IN_HOUR = 60
  HOURS_IN_DAY = 24
  DAYS_IN_WEEK = 7

  def ago
    Time.now - self
  end

  def seconds
    self
  end
  alias :second :seconds

  def minutes
    self * SECONDS_IN_MINUTE
  end
  alias :minute :minutes

  def hours
    self.minutes * MINUTES_IN_HOUR
  end
  alias :hour :hours

  def days
    self.hours * HOURS_IN_DAY
  end
  alias :day :days

  def weeks
    self.days * DAYS_IN_WEEK
  end
  alias :week :weeks

end
