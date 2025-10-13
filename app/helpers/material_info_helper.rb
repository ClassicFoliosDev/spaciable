# frozen_string_literal: false

module MaterialInfoHelper
  def cell_class(column)
    c = column % 4
    return "info-right" if c == 2

    return "info" if c < 2

    "info-left"
  end
end
