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

  def image_link_to(object, url, image_tag_options = {}, link_to_options = {})
    return nil unless object.picture?
    return image_tag object.picture.url unless can?(:read, object)

    link_to url, link_to_options do
      image_tag object.picture.url, image_tag_options
    end
  end
end
