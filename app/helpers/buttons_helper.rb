# frozen_string_literal: true
module ButtonsHelper
  def edit_btn(edit_path, label = "")
    link_to edit_path, class: "btn", data: { action: "edit" } do
      icon "pencil", label
    end
  end

  def delete_btn(resource, label = "", path: nil)
    content_tag(:button, data: data_to_delete(resource, path: path), class: "archive-btn") do
      icon "trash", label
    end
  end

  def icon(icon_name, label = "", classes: "")
    icon_classes = "fa fa-#{icon_name} #{classes}"
    options = { class: icon_classes }

    content_tag(:i, label, options)
  end
end
