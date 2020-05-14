# frozen_string_literal: true

# Timeline Task actions.
class Action < ApplicationRecord
  belongs_to :task

  validates :title, presence: true
  validates :link, presence: true
end
