# frozen_string_literal: true
class ResidentNotification < ApplicationRecord
  belongs_to :resident, class_name: "User", foreign_key: :resident_id
  belongs_to :notification
end
