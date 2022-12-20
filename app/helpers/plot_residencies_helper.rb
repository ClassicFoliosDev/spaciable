# frozen_string_literal: true

module PlotResidenciesHelper
  def roles_collection(full = false)
    roles = []
    PlotResidency.roles.map do |(role_name, _role_int)|
      next if role_name == "prospect" && !full
      roles << [t(role_name, scope: role_scope), role_name]
    end

    roles
  end

  private

  def role_scope
    "activerecord.attributes.plot_residency.roles"
  end
end
