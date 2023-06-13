class HolidaySearch
  def next_three_us_holidays
    service.upcoming_us_holidays[0..2]
  end

  def service
    HolidayService.new
  end
end