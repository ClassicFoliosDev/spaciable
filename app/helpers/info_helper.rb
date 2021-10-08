# frozen_string_literal: true

module InfoHelper
  def data_to_inform(resource, title, text: nil, cancel: t("back"))
    {
      id: resource&.id,
      name: text ? "" : resource.to_s,
      cancel: cancel || t("back"),
      title: title,
      text: text,
      cta: t("buttons.info.title"),
      action: :information
    }
  end
end
