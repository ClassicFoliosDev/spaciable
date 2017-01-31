# frozen_string_literal: true
module ApplianceFixture
  module_function

  def name
    "Bosch washing machine"
  end

  def updated_name
    "AEG washing machine"
  end

  def description
    "Some text\nSome more text"
  end

  def description_display
    "Some text\r\nSome more text"
  end

  def warranty_len
    "8 years"
  end

  def e_rating
    "A++"
  end

  def category
    "Freezer"
  end

  def updated_category
    "Washing Machine"
  end

  def manufacturer
    "Samsung"
  end

  def updated_manufacturer
    "AEG"
  end

  def updated_attrs
    {
      category: updated_category,
      manufaturer: updated_manufacturer,
      warranty_len: warranty_len,
      e_rating: e_rating
    }
  end
end
