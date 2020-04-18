# frozen_string_literal: true

# Timeline Task actions.  Actions have different action_types
class Action < ApplicationRecord
  include ActionTypeEnum
  belongs_to :task, required: true
end
