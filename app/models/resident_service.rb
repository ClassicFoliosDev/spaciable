# frozen_string_literal: true

class ResidentService < ApplicationRecord
  self.table_name = "residents_services"

  belongs_to :resident, dependent: :destroy
  belongs_to :service, dependent: :destroy

  validates :service_id, uniqueness: { scope: :resident_id }
end
