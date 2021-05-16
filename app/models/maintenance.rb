# frozen_string_literal: true

class Maintenance < ApplicationRecord
  CLIXIFIXID = "ClientId"

  belongs_to :development

  validates :account_type, presence: true

  validate :clixifix_path

  # A clixifix maintenance link must contain the clientID
  def clixifix_path
    return unless clixifix?
    return if path.include?(CLIXIFIXID)

    errors.add(:path, "Link must contain '#{CLIXIFIXID}'")
  end

  enum account_type: %i[
    standard
    full_works
    clixifix
  ]
end
