# frozen_string_literal: true

module AdminNavigationHelper
  # rubocop:disable Metrics/MethodLength
  def my_admin_area_url(user)
    permission_level = user.permission_level
    case permission_level
    when Development
      if user.developments.count > 1
        developments_path
      elsif permission_level.division.present?
        url_for([permission_level.division,
                 permission_level])
      else
        url_for([permission_level.developer,
                 permission_level])
      end
    when Division
      if user.developers.count > 1
        divisions_path
      else
        url_for([permission_level.developer,
                 permission_level])
      end
    when Developer
      if user.developers.count > 1
        developers_path
      else
        url_for(permission_level)
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  def my_admin_area_title(user)
    count = 1
    case user.permission_level
    when Development
      count = user.developments.count
    when Division
      count = user.divisions.count
    when Developer
      count = user.developers.count
    end

    user.permission_level.model_name.to_s.pluralize(count)
  end
end
