# frozen_string_literal: true

# Timeline Task actions.
class TaskContact < ApplicationRecord
  include ContactTypeEnum
  belongs_to :task
end
