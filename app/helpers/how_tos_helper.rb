# frozen_string_literal: true

module HowTosHelper
  def how_to_category_collection
    HowTo.categories.map do |(category_name, _category_int)|
      [t(category_name, scope: how_to_category_scope), category_name]
    end
  end

  private

  def how_to_category_scope
    "activerecord.attributes.how_to.categories"
  end
end
