# frozen_string_literal: true

module Ahoy
  class Event < ApplicationRecord
    include Ahoy::QueryMethods
    include AhoyEventEnum

    self.table_name = "ahoy_events"

    belongs_to :visit
    belongs_to :userable, polymorphic: true
  end
end
