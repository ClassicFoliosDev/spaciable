# frozen_string_literal: true

class Address < ApplicationRecord
  include Webhook::Observable

  acts_as_paranoid
  belongs_to :addressable, polymorphic: true

  def to_s
    "#{postal_number} #{road_name}"
  end
end
