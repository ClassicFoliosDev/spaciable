# frozen_string_literal: true
module PlotCompareService
  module_function

  include Comparable

  def call(plot_a, plot_b)
    prefix_a = plot_a.prefix
    prefix_b = plot_b.prefix

    compare_prefix_result = compare_prefix(prefix_b, prefix_a)
    return compare_prefix_result unless compare_prefix_result.zero?

    preferred = plot_a.number <=> plot_b.number
    compare_number(plot_a.number.scan(/\d+/), plot_b.number.scan(/\d+/), preferred)
  end

  private

  module_function

  def compare_number(integer_array_a, integer_array_b, preferred)
    integer_a = integer_b = 0
    counter = 0
    still_more_tokens = true

    while integer_a == integer_b && still_more_tokens
      if integer_array_a.length <= counter || integer_array_b.length <= counter
        return compare_length(integer_array_a, integer_array_b, preferred)
      end

      integer_a = integer_array_a[counter]
      integer_b = integer_array_b[counter]
      still_more_tokens = integer_array_a.length > counter || integer_array_b.length > counter
      counter += 1
    end

    integer_a.to_i <=> integer_b.to_i
  end

  def compare_length(array_a, array_b, preferred)
    return -1 if array_b.length > array_a.length
    return preferred if array_a.length == array_b.length
    1
  end

  def compare_prefix(a, b)
    return 0 if a == b

    b <=> a
  end
end
