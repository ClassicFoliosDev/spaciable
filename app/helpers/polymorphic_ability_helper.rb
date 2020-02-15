# frozen_string_literal: true

module PolymorphicAbilityHelper
  def can_create(type, parent)
    # CF admin can do everything
    return true if current_user.cf_admin?

    return true if cas? type, parent

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
  # rubocop:disable  Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def cas?(type, parent)
    # If the parent is a Development and the 'type' has a development_id column
    if (parent.is_a? Development) && type.column_names.include?("development_id")
      return true if can? :create, type.new(development_id: parent.id)
    # if the parent has a development_id column and the type the 'type'
    # has a development_id column
    elsif parent&.has_attribute?(:development_id) &&
          type.column_names.include?("development_id")
      return true if can? :create, type.new(development_id: parent.development_id)
    # if the type has a [parent_class].id column then it will also have a
    # [paremt] foreign key relationship and so we can set that using the parent object
    # for security testing purposes
    elsif type.column_names.include?("#{parent.class.to_s.downcase}_id")
      return true if can? :create, type.new(parent.class.to_s.downcase.to_sym => parent)
    elsif can? :create, type
      return true
    end

    false
  end
  # rubocop:enable  Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
end
