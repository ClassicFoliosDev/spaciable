# frozen_string_literal: true
module PlotCompareService
  module_function

  include Comparable

  def call(plot_a, plot_b)
    prefix_a = plot_a.prefix
    prefix_b = plot_b.prefix

    compare_prefix_result = compare_prefix(prefix_b, prefix_a)
    return compare_prefix_result unless compare_prefix_result.zero?

    tie_breaker = if plot_a.number.length == plot_b.number.length
                    0
                  elsif plot_a.number.length > plot_b.number.length
                    1
                  else
                    -1
                  end

    compare_number(plot_a.number.scan(/\d+/), plot_b.number.scan(/\d+/), tie_breaker)
  end

  private

  module_function

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable MethodLength
  def compare_number(integer_array_a, integer_array_b, tie_breaker)
    integer_a = integer_b = 0
    counter = 0
    still_more_tokens = true

    while integer_a == integer_b && still_more_tokens
      if integer_array_a.length > counter && integer_array_b.length > counter
        integer_a = integer_array_a[counter]
        integer_b = integer_array_b[counter]
        still_more_tokens = integer_array_a.length > counter || integer_array_b.length > counter
        counter += 1
      elsif integer_array_a.length == integer_array_b.length
        return tie_breaker
      elsif integer_array_b.length > integer_array_a.length
        return -1
      else
        return 1
      end
    end

    integer_a.to_i <=> integer_b.to_i
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable MethodLength

  def compare_prefix(a, b)
    return 0 if a == b

    b <=> a
  end
end
