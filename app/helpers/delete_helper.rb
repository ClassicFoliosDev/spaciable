# frozen_string_literal: true

module DeleteHelper
  def data_to_delete(resource, path: nil)
    {
      id: resource.id,
      url: path || url_for(resource),
      name: resource.to_s,
      cancel: t("destroy.cancel"),
      title: t("destroy.confirm_title"),
      text: t("destroy.confirm_text", type: resource.class.model_name.human),
      cta: t("destroy.destroy"),
      action: :delete
    }
  end
end
