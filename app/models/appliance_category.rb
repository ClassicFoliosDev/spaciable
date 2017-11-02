# frozen_string_literal: true

class ApplianceCategory < ApplicationRecord
  belongs_to :appliance, optional: true

  validates :name, presence: true, uniqueness: true

  def to_s
    name
  end
end
