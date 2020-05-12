# frozen_string_literal: true

module CancelHelper
  def data_to_cancel(title, path:, text: "")
    {
      title: title,
      url: path,
      cancel: t("back"),
      text: text,
      cta: t("buttons.cancel.confirm"),
      action: :cancel
    }
  end
end
