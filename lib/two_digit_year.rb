require 'chronic'

class TwoDigitYear
  # https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2019-format-two-digit-years-correctly
  # http://chronic.rubyforge.org/
  # http://chronic.rubyforge.org/classes/Chronic.html
  class << self
    def compensate_for_two_digit_year(date, cutoff_year = Date.today.strftime("%y").to_i)
      return nil if date.nil?
      d = Chronic.parse(date) || Date.parse(date, false) # setting 2nd argument to false turns off Ruby's 1969-based compensation
      y = d.year % 100 # get the two digit year no matter what
      Date.parse("#{y > cutoff_year ? '19' : '20'}#{'%02d'%y}-#{'%02d'%d.month}-#{'%02d'%d.day}") # re-parse with our own cutoff
    end
  end
end