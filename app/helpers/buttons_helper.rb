# frozen_string_literal: true
module ButtonsHelper
  def view_btn(view_path, label = "")
    link_to view_path, class: "btn", data: { action: "view" } do
      icon "eye", label
    end
  end

  def edit_btn(edit_path, label = "", element:)
    return if element && (cannot? :update, element)

    link_to edit_path, class: "btn", data: { action: "edit" } do
      icon "pencil", label
    end
  end

  def edit_modal(resource, label = "", path: nil, element:)
    return if element && (cannot? :destroy, element)

    content_tag(:button, data: data_to_edit(resource, path: path), class: "btn edit-modal") do
      icon "pencil", label
    end
  end

  def delete_btn(resource, label = "", path: nil, element:)
    return if element && (cannot? :destroy, element)

    content_tag(:button, data: data_to_delete(resource, path: path), class: "btn archive-btn") do
      icon "trash", label
    end
  end

  def icon(icon_name, label = "", classes: "")
    icon_classes = "fa fa-#{icon_name} #{classes}"
    options = { class: icon_classes }

    content_tag(:i, label, options)
  end
end
