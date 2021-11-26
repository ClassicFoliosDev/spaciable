# frozen_string_literal: true

module ButtonsHelper
  def view_btn(view_path, label = "")
    link_to view_path, class: "btn", data: { action: "view" } do
      icon "search-plus", label
    end
  end

  def edit_btn(edit_path, label = "", element:, override: false)
    return unless override || (element && (can? :update, element))

    link_to edit_path, class: "btn", data: { action: "edit" }, title: I18n.t("buttons.edit") do
      icon "pencil", label
    end
  end

  def edit_modal(resource, label = "", path: nil, element:)
    return if element && (cannot? :destroy, element)

    content_tag(:button, data: data_to_edit(resource, path: path),
                         class: "btn edit-modal",
                         title: I18n.t("buttons.edit")) do
      icon "pencil", label
    end
  end

  # rubocop:disable Metrics/ParameterLists
  def delete_btn(resource, label = "", path: nil, text: nil, element:, override: false)
    return unless override || (element && (can? :destroy, element))

    content_tag(:button, data: data_to_delete(resource, path: path, text: text),
                         class: "btn archive-btn",
                         title: I18n.t("buttons.trash")) do
      icon "trash-o", label
    end
  end

  def delete_lnk(delete_path, text:, element: nil, confirm: false, override: false)
    return unless override || (element && (can? :destroy, element))

    link_to delete_path, class: "btn remove #{'archive-lnk' if confirm}", data: { text: text } do
      icon "trash-o", ""
    end
  end
  # rubocop:enable Metrics/ParameterLists

  def info_btn(resource, label = "", title: t("buttons.info.title"), text: nil, element:)
    return if element && (cannot? :destroy, element)

    content_tag(:button, data: data_to_inform(resource, title, text: text),
                         class: "btn info-btn",
                         title: I18n.t("buttons.info.title")) do
      icon "info", label
    end
  end

  def cancel_btn(label, path:, text:, title:)
    content_tag(:a, label,
                data: data_to_cancel(title, path: path, text: text),
                class: "btn cancel-btn")
  end

  def permissable_delete_btn(resource, path: nil, element:)
    return if element && (cannot? :destroy, element)

    button_tag "", class: "btn destroy-permissable",
                   data: permissable_data_to_delete(resource, path: path) do
      icon "trash-o"
    end
  end

  def submit_confirm_btn(title: t("buttons.submit.title"),
                         header: I18n.t("buttons.confirm_dialog.title"),
                         text: nil)
    submit_tag title,
               data: { header: header, text: text },
               class: "btn-form-submit-confirm btn-form-submit btn-primary"
  end

  def icon(icon_name, label = "", classes: "")
    icon_classes = "fa fa-#{icon_name} #{classes}"
    options = { class: icon_classes }

    content_tag(:i, label, options)
  end

  def reinvite_btn(resource, path)
    content_tag(:button, data: resident_to_reinvite(resource, path),
                         class: "btn reinvite-btn") do
      icon "envelope-o"
    end
  end

  def clone_btn(clone_path, label = "", element:)
    return unless element && (can? :clone, element)

    link_to clone_path, class: "btn", data: { action: "clone" }, title: I18n.t("buttons.clone") do
      icon "files-o", label
    end
  end
end
