# frozen_string_literal: true

module PolymorphicAbilityHelper
  def can_create(type, parent, combine: false)
    # CF admin can do everything
    return true if current_user.cf_admin?

    return true if cas? type, parent, combine

    # Every admin user can add a plot resident
    return true if type == PlotResidency

    association = type.name.underscore.pluralize.to_sym
    return false unless parent.respond_to?(association)

    target = parent.send(association).build
    can? :create, target
  end

  private

  # Non CF Admins have dynamic :create permissions for particular types.  We need
  # to instantiate a class that contains the development_id in order for the
  # can? to check permissions.  It is not a straightforward operation and different
  # combinations of type/parent relationships need to be handled differently
  def cas?(type, parent, combine)
    params = {}

    # Set development id from parent
    if type.column_names.include?("development_id") &&
       (parent&.has_attribute?(:development_id) || parent.is_a?(Development))
      params[:development_id] = parent.is_a?(Development) ? parent.id : parent.development_id
    end

    # if the type has a [parent_class].id column then it will also have a
    # [paremt] foreign key relationship and so we can set that using the parent object
    # for security testing purposes
    parent_name = parent&.class&.table_name&.singularize
    if type.column_names.include?("#{parent_name}_id")
      params[parent_name.to_sym] = parent
    end

    return can? :create, type if params.empty?
    action = combine ? "create_#{type}_#{parent.class}".downcase.to_sym : :create
    can? action, type.new(params)
  end
end
