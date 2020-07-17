# frozen_string_literal: true

module ResourceOverviewHelper
  def administering_admins(resource)
    User.where(permission_level: resource)
  end
end
