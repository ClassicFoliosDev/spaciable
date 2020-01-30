# frozen_string_literal: true

class Maintenance < ApplicationRecord
  belongs_to :development

  validates :account_type, presence: true

  enum account_type: %i[
    standard
    full_works
  ]
end
