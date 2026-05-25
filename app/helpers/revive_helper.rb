# frozen_string_literal: true

module ReviveHelper
  def resident_to_revive(resource, path)
    {
      id: resource.id,
      url: path,
      name: resource.to_s,
      cancel: t("revive.cancel"),
      title: t("revive.confirm_title"),
      text: t("revive.confirm_text"),
      cta: t("revive.revive"),
      action: :reinvite
    }
  end
end
