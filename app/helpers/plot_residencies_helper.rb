# frozen_string_literal: true

module PlotResidenciesHelper
  def roles_collection
    PlotResidency.roles.map do |(role_name, _role_int)|
      [t(role_name, scope: role_scope), role_name]
    end
  end

  private

  def role_scope
    "activerecord.attributes.plot_residency.roles"
  end
end
