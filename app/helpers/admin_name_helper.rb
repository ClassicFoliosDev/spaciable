# frozen_string_literal: false

module AdminNameHelper
  def admin_permission_level(resource)
    case resource.permission_level_type
    when nil
      "Classic Folios"
    when "Developer"
      resource.permission_level_name
    when "Division"
      division = resource.permission_level
      "#{division.developer}, #{division}"
    when "Development"
      development_name(resource.permission_level)
    end
  end

  def development_name(development)
    parent = development.parent
    return "#{parent}, #{development}" if parent.is_a? Developer

    "#{parent.developer}, #{parent}, #{development}"
  end
end
