# frozen_string_literal: true
module AdminNavigationHelper
  def my_admin_area_url(permission_level)
    case permission_level
    when Development
      url_for([permission_level.developer,
               permission_level.division,
               permission_level].compact)
    when Division
      url_for([permission_level.developer,
               permission_level])
    when Developer
      url_for(permission_level)
    end
  end
end
