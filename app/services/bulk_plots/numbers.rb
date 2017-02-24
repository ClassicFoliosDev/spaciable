# frozen_string_literal: true
module BulkPlots
  class Numbers
    NaN = Class.new(StandardError)

    def initialize(range_from: nil, range_to: nil, list: nil)
      @range_from = range_from.to_i
      @range_to = range_to.to_i
      @list = list.to_s
    end
    attr_accessor :range_from, :range_to, :list

    def numbers
      @numbers ||= Array(range_numbers.concat(list_numbers).uniq.sort)
    end

    def self.Number(int_or_float)
      number = int_or_float.respond_to?(:strip) ? int_or_float.strip : int_or_float

      can_be_int = number.to_s == number.to_i.to_s
      can_be_float = number.to_s == number.to_f.to_s
      can_be_converted_to_int = (can_be_int || can_be_float) && number.to_i.to_f == number.to_f

      if can_be_converted_to_int
        number.to_i
      elsif can_be_int
        number.to_i
      elsif can_be_float
        number.to_f
      else
        raise NaN, "cannot convert '#{int_or_float}' into an integer of float"
      end
    end

    def Number(int_or_float)
      self.class.Number(int_or_float)
    end

    private

    def list_numbers
      list.split(",").map(&method(:Number)).compact.select(&:positive?)
    rescue NaN
      []
    end

    def range_numbers
      range = (range_from..range_to)

      range.any? && range.min.positive? ? range.to_a : []
    end
  end
end
