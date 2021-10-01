# frozen_string_literal: true

class ExpandableList
  class << self
    def parse(list)
      nums = list.split(",").map(&:strip)
      # Go through looking for ranges - ie 10~20.  If
      # one is encpuntered then get it processed into a list of seperate entries
      nums.map! { |num| num.include?("~") ? split_range(num) : num }
      nums.flatten.natural_sort
    end

    # Check for the supported kinds of ranges and add them to the array
    def split_range(range)
      # numeric only ranges - 1-19
      if range.match("[0-9]+~[0-9]+").to_s == range
        (range.split("~").first..range.split("~").second).to_a
      # Alphaumeric ranges - D20~D30, F10~F1
      elsif range.match("[A-Za-z]+-?[0-9]+~[A-Za-z]+-?[0-9]+").to_s == range
        AlphaNumericRange.new(range).to_a
      elsif raise "Invalid range #{range}"
      end
    end
  end

  # Generate a range of individual alphanumeric values.  supplied range will be
  # in format eg. D1~D20, or F10~F2
  class AlphaNumericRange
    # Analyse and check the range
    def initialize(range)
      @chars = range.scan(/[A-Za-z]+-?/)
      raise "Invalid range #{range}" if @chars.first != @chars.second
      @nums = range.scan(/[0-9]+/).map!(&:to_i)
      @increment = @nums.first > @nums.second ? -1 : 1
    end

    # Go thorugh and  generate the entries into an array
    def to_a
      num = @nums.first
      range = []
      loop do
        range << "#{@chars.first}#{num}"
        break if num == @nums.second
        num += @increment
      end
      range
    end
  end
end
