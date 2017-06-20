# frozen_string_literal: true
module FinishFixture
  module_function

  def finish_name
    "Flooring"
  end

  def updated_name
    "Ideal standard basin"
  end

  def description
    "Some text\nSome more text"
  end

  def description_display
    "Some text\r\nSome more text"
  end

  def category
    "Flooring"
  end

  def updated_category
    "Sanitaryware"
  end

  def type
    "Carpet"
  end

  def updated_type
    "Basin"
  end

  def manufacturer
    "Abode"
  end

  def updated_attrs
    {
      category: updated_category,
      type: updated_type,
      manufacturer: manufacturer
    }
  end
end
