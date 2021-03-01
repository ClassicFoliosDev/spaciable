# frozen_string_literal: true

module ApplicationHelper
  def navigation_link(path, icon, label, base_link_class, target = "_self")
    render partial: "components/navbar_item",
           locals: link_locals(path, icon, label, base_link_class, target)
  end

  private

  def link_locals(path, icon, label, base_link_class, target)
    {
      path: path,
      link_class: link_class(path, base_link_class),
      icon: icon,
      label: label,
      target: target
    }
  end

  def link_class(path, base_link_class)
    return base_link_class unless current_page?(path)

    base_link_class + " active"
  end
end
