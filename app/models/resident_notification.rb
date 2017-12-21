# frozen_string_literal: true

class ResidentNotification < ApplicationRecord
  belongs_to :resident
  belongs_to :notification

  validates :resident, uniqueness: { scope: :notification }
end
