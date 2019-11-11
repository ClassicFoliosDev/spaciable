# frozen_string_literal: true

class Country < ApplicationRecord
  # Centralised function to identify UK
  def uk?
    name == "UK"
  end

  def spain?
    name == "Spain"
  end

  def alpha_code
    uk? ? "GB" : "ES"
  end
end
