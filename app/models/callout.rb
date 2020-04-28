# frozen_string_literal: true

# Timeline Task actions.  Actions have different action_types
class Callout < ApplicationRecord
  include CalloutTypeEnum
  belongs_to :task, required: true

  validates :title,presence: true
  validates :link,presence: true

  def populated?
    title.present? || description.present? || link.present?
  end
end
