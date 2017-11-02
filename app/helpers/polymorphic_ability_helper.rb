# frozen_string_literal: true

module PolymorphicAbilityHelper
  def can_create(type, parent)
    # CF admin can do everything
    return true if current_user.cf_admin?
    # Every admin user can add a plot resident
    return true if type == PlotResidency

    association = type.name.underscore.pluralize.to_sym
    return false unless parent.respond_to?(association)

    target = parent.send(association).build
    can? :create, target
  end
end
