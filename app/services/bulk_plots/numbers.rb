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

    def list_numbers
      list.split(",").map(&method(:Number)).compact
    end

    def range_numbers
      range = (range_from..range_to)

      range.any? && range.min.positive? ? range.to_a : []
    end
  end
end
