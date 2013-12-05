class Fixnum
  SECONDS_IN_DAY = 24 * 60 * 60
  def days
    self * SECONDS_IN_DAY
  end

  def ago
    Time.now - self
  end
end
