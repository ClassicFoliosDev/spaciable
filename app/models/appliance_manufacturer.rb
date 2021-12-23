# frozen_string_literal: true

class ApplianceManufacturer < ApplicationRecord
  belongs_to :developer, optional: true
  validates :name, presence: true,
                   uniqueness:
                   {
                     scope: %i[developer],
                     case_sensitive: false
                   }

  delegate :to_s, to: :name
end
