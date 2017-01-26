# frozen_string_literal: true
module ApplianceFixture
  module_function

  def name
    "Bosch washing machine"
  end

  def updated_name
    "Zanussi washing machine"
  end

  def model_num
    "WAB28161G"
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

  def manufacturer
    "Samsung"
  end

  def dropdown_attrs
    {
      category: category,
      manufaturer: manufacturer
    }
  end

  def update_attrs
    {
      name: updated_name,
      model_num: model_num
    }
  end
end
