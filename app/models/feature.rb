# frozen_string_literal: true

# Timeline Task features
class Feature < ApplicationRecord
  belongs_to :task

  validates :title, presence: true
  validates :description, presence: true
  validates :link, presence: true
end
