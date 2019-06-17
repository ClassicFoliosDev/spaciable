# frozen_string_literal: true

module AdminNavigationHelper
  # rubocop:disable Metrics/MethodLength
  def my_admin_area_url(permission_level)
    case permission_level
    when Development
      if permission_level.division.present?
        url_for([permission_level.division,
                 permission_level])
      else
        url_for([permission_level.developer,
                 permission_level])
      end
    when Division
      url_for([permission_level.developer,
               permission_level])
    when Developer
      url_for(permission_level)
    end
  end
  # rubocop:enable Metrics/MethodLength
end
