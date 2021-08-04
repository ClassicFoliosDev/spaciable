# frozen_string_literal: true

# Timeline Task actions.
class Grant < ApplicationRecord
  include RoleEnum

  belongs_to :user
  belongs_to :grantable, polymorphic: true

  def developer
    return grantable.identity if grantable.is_a? Developer
    return grantable.developer.identity if grantable.is_a? Division
    grantable.parent_developer.identity
  end

  def division
    return grantable.identity if grantable.is_a? Division
    return grantable&.division&.identity if grantable.is_a? Development
    nil
  end

  def development
    return nil unless grantable.is_a? Development
    grantable.identity
  end
end
