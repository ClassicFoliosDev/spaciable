# frozen_string_literal: true
module SortingHelper
  def sortable(klass, column, title = nil, sort_params: {}, html_options: { class: "both" })
    return sort_on_association(klass, column, title) if klass.is_a? Hash

    title ||= klass.human_attribute_name(column)

    sort_params.merge!(active_tab: params[:active_tab], sort: column, direction: "desc")

    if params[:sort] == column.to_s
      direction = params[:direction] == "asc" ? "desc" : "asc"

      sort_params[:sort] = column
      sort_params[:direction] = direction
      html_options[:class] = direction
    end

    link_to title, sort_params, html_options
  end

  def sort_on_association(hash, column, title)
    klass = hash.to_a.last.last
    title ||= klass.model_name.human.to_s
    sort_params = { sort_on: klass.model_name.param_key }

    sortable(klass, column, title, sort_params: sort_params)
  end
end
