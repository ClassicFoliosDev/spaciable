# frozen_string_literal: true
module TabsHelper
  def tabs_for(parent, active_tab)
    method_name = "#{parent.model_name.element}_tabs"
    send(method_name, parent, active_tab)
  end

  Tabs = Struct.new(:scope, :tabs, :current_tab, :view_context) do
    BuildHasOneAssociationPermissionsError = Class.new(StandardError)

    def all
      tabs.each_pair.map do |association, options|
        next if cannot_read?(association, options.delete(:permissions_on))

        Tab.new(
          options.reverse_merge(
            active: current_tab == association.to_s,
            title: title(association),
            link: [scope, association]
          )
        ).to_a
      end.compact
    end

    def cannot_read?(association, permissions_scope = nil)
      model = permissions_scope&.call || build_association(association)

      view_context.cannot? :read, model
    end

    def build_association(association)
      return scope.send(association).build unless one_to_one_association?(association)
      raise BuildHasOneAssociationPermissionsError, build_has_one_error
    end

    def one_to_one_association?(association)
      association.to_s == association.to_s.singularize
    end

    def build_has_one_error
      <<-ERROR
        Tabs for singular resources cannot automatically check the permissions on a has_one association.
        Doing so would delete the existing association: `@plot.build_plot_residency` deletes the plot residency record.

        To avoid this, set the `permission_on` options when building that tab which uses the belongs_to model to
        populate the association: `permissions_on: -> { PlotResidence.new(plot_id: plot.id) }`.
      ERROR
    end

    def build_has_one_error
      <<-ERROR
        Tabs for singular resources cannot automatically check the permissions on a has_one association.
        Doing so would delete the existing association: `@plot.build_plot_residency` deletes the plot residency record.

        To avoid this, set the `permission_on` options when building that tab which uses the belongs_to model to
        populate the association: `permissions_on: -> { PlotResidence.new(plot_id: plot.id) }`.
      ERROR
    end

    def title(key)
      I18n.t("#{scope.model_name.plural}.collection.#{key}")
    end
  end

  class Tab
    attr_reader :title, :icon, :link, :active

    def initialize(title:, icon:, link:, active:)
      @title = title
      @icon = icon
      @link = link
      @active = active
    end

    def active?
      active == true
    end

    def to_a
      [title, icon, link, active?]
    end
  end
end
