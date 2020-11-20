# frozen_string_literal: true

module ReinviteHelper
  def resident_to_reinvite(resource, path)
    {
      id: resource.id,
      url: path,
      name: resource.to_s,
      cancel: t("reinvite.cancel"),
      title: t("reinvite.confirm_title"),
      text: t("reinvite.confirm_text"),
      cta: t("reinvite.reinvite"),
      action: :reinvite
    }
  end
end
