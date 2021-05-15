# frozen_string_literal: true

module ChartHelper
  # The roles are a heirarchy starting at 0 (cf_admin).  The required filter is
  # disabled unless the current user's role is less or equal (i.e. higher or same)
  # than that being requested
  def chart_filter_disabled(required_role)
    User.roles[required_role] < User.roles[current_user.role]
  end
end
