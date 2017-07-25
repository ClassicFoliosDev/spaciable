# frozen_string_literal: true
class Service < ApplicationRecord
  acts_as_paranoid

  belongs_to :development, optional: false

  validates :name, presence: true, uniqueness: { scope: :development_id }
end
