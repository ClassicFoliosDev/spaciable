# frozen_string_literal: true
module ContactFixture
  module_function

  def first_name
    "John"
  end

  def last_name
    "Doe"
  end

  def email
    "concierge@foo.com"
  end

  def updated_email
    "warranty@widgets.com"
  end

  def phone
    "01962 543678"
  end

  def title
    "Ms"
  end

  def category
    "Warranty Provider"
  end

  def updated_name
    "Jane"
  end

  def updated_attrs
    {
      category: category,
      title: title,
      phone: phone,
      email: updated_email
    }
  end
end
