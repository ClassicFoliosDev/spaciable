# frozen_string_literal: true

module AdminSnagPermissionsHelper
  def access_to_snagging(current_ability)
    current_user.cf_admin? || snagging_enabled?(current_ability)
  end

  def snagging_enabled?(current_ability)
    snagging = false
    Development.accessible_by(current_ability).each do |development|
      snagging ||= development.enable_snagging
    end
    snagging
  end
end
