# frozen_string_literal: true

class LettingsAccount < ApplicationRecord
  has_many :lettings
  belongs_to :letter, polymorphic: true

  enum management: {
    self_managed: 0,
    management_service: 1
  }
end
