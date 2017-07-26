# frozen_string_literal: true
module EditHelper
  def data_to_edit(resource, path: nil)
    {
      url: path || url_for(resource),
      name: resource.to_s,
      cancel: t("destroy.cancel"),
      title: t("edit.title"),
      cta: t("edit.submit"),
      action: :update
    }
  end
end
