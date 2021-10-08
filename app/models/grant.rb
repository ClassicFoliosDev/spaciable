# frozen_string_literal: true

# Timeline Task actions.
class Grant < ApplicationRecord
  include RoleEnum

  belongs_to :user
  belongs_to :permission_level, polymorphic: true
  delegate :cas, to: :user

  def developer
    return permission_level.identity if permission_level.is_a? Developer
    return permission_level.developer.identity if permission_level.is_a? Division
    permission_level.parent_developer.identity
  end

  def division
    return permission_level.identity if permission_level.is_a? Division
    return permission_level&.division&.identity if permission_level.is_a? Development
    nil
  end

  def development
    return nil unless permission_level.is_a? Development
    permission_level.identity
  end

  # is the provided developer the same as that associated with this grant?
  def at_developer(development_id)
    return permission_level_id == development_id if permission_level.is_a? Developer
    return permission_level.developer_id == development_id if permission_level.is_a? Division
    permission_level.parent_developer_id == development_id
  end
end
