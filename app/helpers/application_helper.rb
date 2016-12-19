# frozen_string_literal: true
module ApplicationHelper
  def navigation_link(path, icon, label, base_link_class)
    render partial: "components/navbar_item",
           locals: link_locals(path, icon, label, base_link_class)
  end

  private

  def link_locals(path, icon, label, base_link_class)
    {
      path: path,
      link_class: link_class(path, base_link_class),
      icon: icon,
      label: label
    }
  end

  def link_class(path, base_link_class)
    return base_link_class unless current_page?(path)

    base_link_class + " active"
  end

  def sortable(klass, column)
    title = klass.human_attribute_name(column)

    if params[:sort] == column.to_s
      direction = params[:direction] == "asc" ? "desc" : "asc"
      link_to title, { sort: column, direction: direction }, class: direction
    else
      link_to title, { sort: column, direction: "desc" }, class: "both"
    end
  end
end
