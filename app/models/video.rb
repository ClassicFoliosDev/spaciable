# frozen_string_literal: true

class Video < ApplicationRecord
  belongs_to :videoable, polymorphic: true

  validates :title, presence: true
  validates :link, presence: true

  delegate :to_s, to: :title
end
