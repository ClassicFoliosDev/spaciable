# frozen_string_literal: true

module Admin
  module SelectOptionsHelper
    # rubocop:disable Metrics/ParameterLists
    def cascade_select_input(form, attribute, source_model = Developer, blank: -> { true },
                             show_all: false, label: nil)
      selected_id = form.object.send(attribute) || current_user.send(attribute)
      form.input attribute, label: (label.present? ? label : source_model.to_s) do
        form.select(
          attribute,
          selected_option(selected_id, source_model),
          { selected: selected_id,
            include_blank: blank.call },
          "data-all-option" => show_all
        )
      end
    end
    # rubocop:enable Metrics/ParameterLists

    private

    def selected_option(selected_id, klass = Developer)
      return [] unless selected_id

      record = klass.accessible_by(current_ability).find_by(id: selected_id)

      record ? [[record.to_s, record.id]] : []
    end
  end
end
