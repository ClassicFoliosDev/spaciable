# config/initializers/time_formats.rb
Date::DATE_FORMATS[:default] = "%d/%m/%Y"
Time::DATE_FORMATS[:default] = "%d/%m/%Y %H:%M"
DEFAULT_DATETIME_FORMAT = "%d/%m/%Y %H:%M"

class DateTime
  def to_s
    strftime DEFAULT_DATETIME_FORMAT
  end
end

class Date
  def html
    strftime "%Y-%m-%d"
  end
end
