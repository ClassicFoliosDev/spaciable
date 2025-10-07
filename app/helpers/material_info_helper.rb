# frozen_string_literal: false

module MaterialInfoHelper
  def cell_class(column)
    _column = column % 4
    return "info-right" if _column == 2

    return "info" if _column < 2

    "info-left"
  end
end
