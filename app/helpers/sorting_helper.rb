# frozen_string_literal: true
module SortingHelper
  def sortable(klass, column)
    title = klass.human_attribute_name(column)

    if params[:sort] == column.to_s
      direction = params[:direction] == "asc" ? "desc" : "asc"
      link_to title, { sort: column, direction: direction }
        .merge(active_tab: params[:active_tab]), class: direction
    else
      link_to title, { sort: column, direction: "desc" }
        .merge(active_tab: params[:active_tab]), class: "both"
    end
  end
end
