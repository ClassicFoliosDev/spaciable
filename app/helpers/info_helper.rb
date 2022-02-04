# frozen_string_literal: true

module InfoHelper
  # rubocop:disable Metrics/ParameterLists
  def data_to_inform(resource, title, text: nil, cancel: t("back"), width: nil, height: nil)
    {
      id: resource&.id,
      name: text ? "" : resource.to_s,
      cancel: cancel || t("back"),
      title: title,
      text: text,
      cta: t("buttons.info.title"),
      action: :information,
      width: width,
      height: height
    }
  end
  # rubocop:enable Metrics/ParameterLists
end
