# frozen_string_literal: true

module BulkPlots
  class Numbers
    def initialize(range_from: nil, range_to: nil, list: nil)
      @range_from = range_from.to_i
      @range_to = range_to.to_i
      @list = list.to_s
    end
    attr_accessor :range_from, :range_to, :list

    def numbers
      @numbers ||= Array(range_numbers.concat(list_numbers).uniq)
    end

    def self.Number(int_or_float)
      int_or_float.respond_to?(:strip) ? int_or_float.strip : int_or_float
    end

    def Number(int_or_float)
      self.class.Number(int_or_float)
    end

    private

    # process a list that contains comma seperated values and ranges of the form N1~N2
    def list_numbers
      nums = list.split(",").map(&:strip)
      # Go through looking for ranges - ie 10~20.  If
      # one is encpuntered then get it processed into a list of seperate entries
      nums.map! { |num| num.include?("~") ? split_range(num) : num }
      nums.flatten.natural_sort
    end

    def range_numbers
      range = (range_from..range_to)

      range.any? && range.min.positive? ? range.to_a : []
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
