# frozen_string_literal: true
class Address < ApplicationRecord
  acts_as_paranoid
  belongs_to :addressable, polymorphic: true

  def to_s
    postal_name
  end

  # These are the fields that a plot can override:
  # We want to know what the values are so we can test
  # if they have changed
  def to_plot_s
    "#{postcode} #{building_name} #{road_name}"
  end
end
