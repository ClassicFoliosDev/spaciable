# frozen_string_literal: true
module SearchConcern
  extend ActiveSupport::Concern

  def ilike_search(resources, search_term)
    resources.where("LOWER(name) ILIKE LOWER(?)", "%#{search_term}%")
  end
end
