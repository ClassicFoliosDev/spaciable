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
      @numbers ||= Array(range_numbers.concat(list_numbers).uniq.sort)
    end

    private

    def list_numbers
      list.split(",").map(&:to_i).compact.select(&:positive?)
    end

    def range_numbers
      range = (range_from..range_to)

      range.any? && range.min.positive? ? range.to_a : []
    end
  end
end
