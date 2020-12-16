# frozen_string_literal: true

class TourStep < ApplicationRecord
  enum position: %i[
    top
    left
  ]
end
