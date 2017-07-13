# frozen_string_literal: true
module FinishFixture
  module_function

  def finish_name
    "New finish"
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

  def updated_category
    "Sanitaryware"
  end

  def updated_type
    "Basin"
  end

  def updated_manufacturer
    "Villeroy and Boch"
  end

  def updated_attrs
    {
      category: updated_category,
      type: updated_type,
      finish_manufacturer: updated_manufacturer
    }
  end
end
