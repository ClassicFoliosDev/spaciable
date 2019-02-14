# frozen_string_literal: true

module HowTosHelper
  # Get the how_to categories for the country
  def how_to_category_collection(country)
    HowTo.country_categories(country).map do |(category_name)|
      [t(category_name, scope: how_to_category_scope), category_name]
    end
  end

  private

  def how_to_category_scope
    "activerecord.attributes.how_to.categories"
  end
end
