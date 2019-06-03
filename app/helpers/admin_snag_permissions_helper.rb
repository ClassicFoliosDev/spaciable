# frozen_string_literal: true

module AdminSnagPermissionsHelper
  def access_to_snagging(current_user)
    current_user.cf_admin? || non_cf_admin(current_user)
  end

  def non_cf_admin(current_user)
    admin_of = current_user.permission_level_id
    permission_name = current_user.permission_level_type
    case permission_name
    when "Developer"
      get_developer_info(admin_of)
    when "Division"
      get_division_info(admin_of)
    when "Development"
      @developments = Development.where(id: admin_of)
    end
    snagging_enabled?(@developments)
  end

  def get_developer_info(admin_of)
    developer = Developer.find(admin_of)
    @developments = developer.all_developments
  end

  def get_division_info(admin_of)
    division = Division.find(admin_of)
    @developments = division.developments
  end

  def snagging_enabled?(developments)
    snagging = false
    developments.each do |development|
      snagging ||= development.enable_snagging
    end
    snagging
  end
end
