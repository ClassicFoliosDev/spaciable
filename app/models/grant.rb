# frozen_string_literal: true

# Timeline Task actions.
class Grant < ApplicationRecord
  include RoleEnum

  belongs_to :eventable, polymorphic: true
end
