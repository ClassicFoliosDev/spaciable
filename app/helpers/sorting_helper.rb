# frozen_string_literal: true

module SortingHelper
  def sortable(klass, column, title = nil, sort_params: {}, html_options: { class: "both" })
    # duplicate sort parameters so they are not changed on return
    sp = sort_params.dup
    sp[:active_tab] = params[:active_tab]
    return sort_on_association(klass, column, title, sp) if klass.is_a? Hash

    title ||= klass.human_attribute_name(column)

    sp[:sort] = column
    sp[:direction] = "desc"

    if params[:sort] == column.to_s
      direction = params[:direction] == "asc" ? "desc" : "asc"

      sp[:sort] = column
      sp[:direction] = direction
      html_options[:class] = direction
    end

    link_to title, sp, html_options
  end

  def sort_on_association(hash, column, title, sort_params)
    klass = hash.to_a.last.last
    title ||= klass.model_name.human.to_s
    sort_params[:sort_on] = klass.model_name.param_key

    sortable(klass, column, title, sort_params: sort_params)
  end
end
